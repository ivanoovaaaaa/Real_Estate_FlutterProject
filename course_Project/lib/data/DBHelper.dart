import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:course_project/models/user.dart';
import 'package:course_project/models/property.dart';
import 'package:course_project/models/review.dart';
import 'package:course_project/AuthManager.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }



  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'realetate2.db');

    bool exists = await databaseExists(path);

    if (!exists) {
      // Копирование файла базы данных из assets
      ByteData data = await rootBundle.load('assets/realetate2.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }


  Future<List<Map<String, dynamic>>> query(String table) async {
    Database db = await database;
    return await db.query(table);
  }
  Future<bool> isEmailExists(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'Email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<bool> isPhoneExists(String phone) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'Phone = ?',
      whereArgs: [phone],
    );
    return result.isNotEmpty;
  }

  Future<bool> isPassportExists(String passport) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'Passport = ?',
      whereArgs: [passport],
    );
    return result.isNotEmpty;
  }

  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where,
      List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
  Future<int?> getUserIdByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      columns: ['UserID'],
      where: 'Email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['UserID'] as int;
    } else {
      return null;
    }
  }
  Future<bool> isPropertyInFavorites(int userId, int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Favorites',
      where: 'UserId = ? AND PropertyId = ?',
      whereArgs: [userId, propertyId],
    );
    return result.isNotEmpty;
  }
  Future<void> deleteReview(int reviewId) async {
    try {
      // Получаем экземпляр базы данных
      Database db = await database;

      // Выполняем запрос на удаление комментария
      await db.delete(
        'Reviews',
        where: 'ReviewID = ?',
        whereArgs: [reviewId],
      );
    } catch (e) {
      // Обработка ошибок, если необходимо
      print('Ошибка при удалении комментария: $e');
    }
  }
  Future<bool> checkCredentials(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'Email = ? AND Password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
  Future<List<Map<String, dynamic>>> getPropertiesByOwnerId(int ownerId) async {
    final db = await database;
    return await db.query('Property', where: 'OwnerId = ?', whereArgs: [ownerId]);
  }

  Future<List<Map<String, dynamic>>> getFavoritesByPropertyId(int propertyId) async {
    final db = await database;
    return await db.query('Favorites', where: 'PropertyId = ?', whereArgs: [propertyId]);
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('Users', where: 'UserID = ?', whereArgs: [userId]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Property>> getFavoriteProperties() async {
    // Получение ID текущего пользователя
    String? userId = AuthManager.getCurrentUserId();

    if (userId != null) {
      Database db = await database;

      List<Map<String, dynamic>> maps = await db.query(
        'Favorites',
        where: 'UserId = ?',
        whereArgs: [userId],
      );

      // Создаем список для хранения ID избранных объявлений
      List<int> propertyIds = [];

      // Извлекаем ID избранных объявлений из результата запроса
      for (var map in maps) {
        propertyIds.add(map['PropertyId'] as int);
      }

      List<Property> favoriteProperties = [];

      // Получаем данные для каждого избранного объявления
      for (int propertyId in propertyIds) {
        List<Map<String, dynamic>> propertyMap = await db.query(
          'property',
          where: 'Id = ? AND status = ?', // Проверка статуса объявления
          whereArgs: [propertyId, 'ОПУБЛИКОВАНО'],
        );

        if (propertyMap.isNotEmpty) {
          favoriteProperties.add(Property(
            id: propertyMap[0]['Id'],
            title: propertyMap[0]['Title'],
            details: propertyMap[0]['Details'],
            area: propertyMap[0]['Area'],
            numRooms: propertyMap[0]['NumRooms'],
            ownerId: propertyMap[0]['OwnerId'],
            house: propertyMap[0]['House'],
            street: propertyMap[0]['Street'],
            district: propertyMap[0]['District'],
            rentType: propertyMap[0]['RentType'],
            ward: propertyMap[0]['Ward'],
            cost: propertyMap[0]['Cost'],
            floor: propertyMap[0]['Floor'],
            type: propertyMap[0]['Type'],
            yearBuilt: propertyMap[0]['YearBuilt'],
            condition: propertyMap[0]['Condition'],
            status: propertyMap[0]['Status'],
            suitableForChildren: propertyMap[0]['SuitableForChildren'],
            bathroomType: propertyMap[0]['BathroomType'],
            petsAllowed: propertyMap[0]['PetsAllowed'],
            kitchenOptions: propertyMap[0]['KitchenOptions'],
            bathroomOptions: propertyMap[0]['BathroomOptions'],
            householdOptions: propertyMap[0]['HouseholdOptions'],
          ));
        }
      }

      return favoriteProperties;
    } else {
      // Если ID пользователя недоступен, вернуть пустой список
      return [];
    }
  }

  Future<List<Property>> getAllProperties() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
        'property', where: 'status = ?', whereArgs: ['ОПУБЛИКОВАНО']);
    return List.generate(maps.length, (i) {
      return Property(
        id: maps[i]['Id'],
        title: maps[i]['Title'],
        details: maps[i]['Details'],
        area: maps[i]['Area'],
        numRooms: maps[i]['NumRooms'],
        ownerId: maps[i]['OwnerId'],
        house: maps[i]['House'],
        street: maps[i]['Street'],
        district: maps[i]['District'],
        rentType: maps[i]['RentType'],
        ward: maps[i]['Ward'],
        cost: maps[i]['Cost'],
        floor: maps[i]['Floor'],
        type: maps[i]['Type'],
        yearBuilt: maps[i]['YearBuilt'],
        condition: maps[i]['Condition'],
        status: maps[i]['Status'],
        suitableForChildren: maps[i]['SuitableForChildren'],
        bathroomType: maps[i]['BathroomType'],
        petsAllowed: maps[i]['PetsAllowed'],
        kitchenOptions: maps[i]['KitchenOptions'],
        bathroomOptions: maps[i]['BathroomOptions'],
        householdOptions: maps[i]['HouseholdOptions'],
      );
    });
  }
  Future<List<Property>> getAllPropertiesByCurrentUser() async {
    Database db = await database;
    String? userId = AuthManager.getCurrentUserId();
    List<Map<String, dynamic>> maps = await db.query(
        'property', where: 'OwnerId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) {
      return Property(
        id: maps[i]['Id'],
        title: maps[i]['Title'],
        details: maps[i]['Details'],
        area: maps[i]['Area'],
        numRooms: maps[i]['NumRooms'],
        ownerId: maps[i]['OwnerId'],
        house: maps[i]['House'],
        street: maps[i]['Street'],
        district: maps[i]['District'],
        rentType: maps[i]['RentType'],
        ward: maps[i]['Ward'],
        cost: maps[i]['Cost'],
        floor: maps[i]['Floor'],
        type: maps[i]['Type'],
        yearBuilt: maps[i]['YearBuilt'],
        condition: maps[i]['Condition'],
        status: maps[i]['Status'],
        suitableForChildren: maps[i]['SuitableForChildren'],
        bathroomType: maps[i]['BathroomType'],
        petsAllowed: maps[i]['PetsAllowed'],
        kitchenOptions: maps[i]['KitchenOptions'],
        bathroomOptions: maps[i]['BathroomOptions'],
        householdOptions: maps[i]['HouseholdOptions'],
      );
    });
  }
  Future<List<Uint8List?>> getPhotosForProperty(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> photos = await db.query(
      'Photos',
      columns: ['Image'],
      where: 'PropertyId = ?',
      whereArgs: [propertyId],
    );

    List<Uint8List?> images = [];
    for (Map<String, dynamic> photo in photos) {
      images.add(photo['Image'] as Uint8List?);
    }

    return images;
  }
  Future<void> removeProperty(int propertyId) async {
    // Получить экземпляр базы данных
    Database db = await database;
    await db.delete('Favorites', where: 'PropertyId = ?', whereArgs: [propertyId]);
    await db.delete('Photos', where: 'PropertyId = ?', whereArgs: [propertyId]);
    await db.delete('Property', where: 'Id = ?', whereArgs: [propertyId]);
  }
  Future<List<Property>> getPurposeProperties() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
        'property', where: 'status = ?', whereArgs: ['В РАССМОТРЕНИИ']);
    return List.generate(maps.length, (i) {
      return Property(
        id: maps[i]['Id'],
        title: maps[i]['Title'],
        details: maps[i]['Details'],
        area: maps[i]['Area'],
        numRooms: maps[i]['NumRooms'],
        ownerId: maps[i]['OwnerId'],
        house: maps[i]['House'],
        street: maps[i]['Street'],
        district: maps[i]['District'],
        rentType: maps[i]['RentType'],
        ward: maps[i]['Ward'],
        cost: maps[i]['Cost'],
        floor: maps[i]['Floor'],
        type: maps[i]['Type'],
        yearBuilt: maps[i]['YearBuilt'],
        condition: maps[i]['Condition'],
        status: maps[i]['Status'],
        suitableForChildren: maps[i]['SuitableForChildren'],
        bathroomType: maps[i]['BathroomType'],
        petsAllowed: maps[i]['PetsAllowed'],
        kitchenOptions: maps[i]['KitchenOptions'],
        bathroomOptions: maps[i]['BathroomOptions'],
        householdOptions: maps[i]['HouseholdOptions'],
      );
    });
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    print(
        maps); // Добавляем эту строку для вывода результатов запроса в консоль
    return List.generate(maps.length, (i) {
      return User(
        userId: maps[i]['UserID'],
        firstName: maps[i]['FirstName'],
        lastName: maps[i]['LastName'],
        email: maps[i]['Email'],
        password: maps[i]['Password'],
        passport: maps[i]['Passport'],
        phone: maps[i]['Phone'],
      );
    });
  }
  Future<List<Uint8List?>> getAllPhotosForProperty(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Photos',
      where: 'PropertyId = ?',
      whereArgs: [propertyId],
    );

    List<Uint8List?> images = [];
    for (var map in maps) {
      images.add(map['Image']);
    }

    return images;
  }

  Future<Uint8List?> getFirstPhotoForProperty(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Photos',
      where: 'PropertyId = ?',
      whereArgs: [propertyId],
    );
    if (maps.isNotEmpty) {
      return maps.first['Image'];
    } else {
      return null; // Если изображений нет, вернуть null
    }
  }

  Future<double> getAverageRatingForProperty(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT AVG(Rating) AS AverageRating
    FROM Reviews
    WHERE PropertyID = ?
  ''', [propertyId]);

    // Проверяем, есть ли отзывы для данного объявления
    if (maps.isNotEmpty && maps[0]['AverageRating'] != null) {
      return maps[0]['AverageRating'] as double; // Возвращаем средний рейтинг
    } else {
      return 0.0; // Если отзывов нет, возвращаем 0.0
    }
  }

  Future<int> getReviewCountForProperty(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT COUNT(*) AS ReviewCount
    FROM Reviews
    WHERE PropertyID = ?
  ''', [propertyId]);

    // Возвращаем количество отзывов для указанного объявления
    return maps.isNotEmpty ? maps[0]['ReviewCount'] as int : 0;
  }

  Future<User> getOwnerDetails(int ownerId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'UserID = ?',
      whereArgs: [ownerId],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      throw Exception('Owner with ID $ownerId not found');
    }
  }

  Future<User> getUser(int userId) async {
    final db = await database;
    var result = await db.query(
        'Users', where: 'UserID = ?', whereArgs: [userId]);
    return User.fromMap(result.first);
  }


  Future<List<Review>> getAllRev(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'Reviews',
      where: 'PropertyId = ?',
      whereArgs: [propertyId],
    );
    print(
        maps); // Добавляем эту строку для вывода результатов запроса в консоль
    return List.generate(maps.length, (i) {
      return Review(
        reviewId: maps[i]['ReviewID'],
        propertyId: maps[i]['PropertyID'],
        reviewerId: maps[i]['ReviewerID'],
        rating: maps[i]['Rating'],
        comment: maps[i]['Comment'],
      );
    });
  }

  Future<bool> checkIfCurrentUserIsOwner(int propertyId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Property',
        columns: ['OwnerId'], where: 'Id = ?', whereArgs: [propertyId]);
    if (results.isNotEmpty) {
      int ownerId = results.first['OwnerId'];
      String? currentUserId = AuthManager.getCurrentUserId();
      return ownerId.toString() == currentUserId;
    }
    return false;
  }

  Future<bool> checkIfUserHasReview(int propertyId) async {
    Database db = await database;
    String? currentUserId = AuthManager.getCurrentUserId();
    List<Map<String, dynamic>> results = await db.query('Reviews',
        columns: ['ReviewID'],
        where: 'PropertyID = ? AND ReviewerID = ?',
        whereArgs: [propertyId, currentUserId]);
    return results.isNotEmpty;
  }

  Future<void> saveReview(int propertyId, String comment, int rating) async {
    Database db = await database;
    String? currentUserId = AuthManager.getCurrentUserId();
    Review review = Review(
      propertyId: propertyId,
      reviewerId: int.parse(currentUserId!),
      rating: rating,
      comment: comment,
    );
    await db.insert('Reviews', review.toMap());
  }

  Future<void> approveProperty(int id) async {
    Database db = await database;
    await db.update(
      'Property', // Имя таблицы
      {'Status': 'ОПУБЛИКОВАНО'}, // Обновляемое значение столбца
      where: 'Id = ?', // Условие выборки записи для обновления
      whereArgs: [id], // Аргументы условия выборки
    );
  }

  Future<void> deleteProperty(int id) async {
    Database db = await database;
    await db.delete(
      'Property', // Имя таблицы
      where: 'Id = ?', // Условие выборки записи для удаления
      whereArgs: [id], // Аргументы условия выборки
    );
  }
  Future<Property?> getPropertyById(int id) async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'Property',
      where: 'Id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Property.fromMap(maps.first);
    }
    return null;
  }
  Future<int> insertProperty(Database db, Property property) async {
    return await db.insert('Property', property.toMap());
  }

  Future<int> updateProperty(Database db, Property property,int propertyId) async {
    await db.delete('Photos', where: 'PropertyId = ?', whereArgs: [propertyId]);
    // Исключаем поле 'id' из данных для обновления
    Map<String, dynamic> propertyData = property.toMap();
    propertyData.remove('id');
    propertyData.remove('ownerId');

    // Выполняем операцию обновления данных в таблице 'Property' без изменения поля 'id'
    return await db.update('Property', propertyData, where: 'id = ?', whereArgs: [propertyId]);
  }

  // Метод для вставки фотографии
  Future<int> insertPhoto(Database db, Uint8List? imageBytes,
      int propertyId) async {
    return await db.insert(
        'Photos', {'Image': imageBytes, 'PropertyId': propertyId});
  }
}






