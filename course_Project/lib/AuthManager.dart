import 'package:course_project/models/property.dart';
import 'package:course_project/data/DBHelper.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _loggedInKey = 'isLoggedIn';
  static String? _currentUser;
  static String? _currentUserId;

  // Проверка состояния входа пользователя
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Метод входа в систему
  static Future<void> login(String email, String password) async {
    // Проверка учетных данных пользователя
    DatabaseHelper db = DatabaseHelper(); // Инициализация вашего DatabaseHelper
    bool isLoggedIn = await db.checkCredentials(email, password);
    if (isLoggedIn) {
      // Получение ID пользователя по его email
      int? userId = await db.getUserIdByEmail(email);
      if (userId != null) {
        // Установка информации о текущем пользователе
        _currentUser = email; // Имя пользователя
        _currentUserId = userId.toString(); // Преобразование ID в строку и установка
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(_loggedInKey, true);
      } else {
        throw Exception('Не удалось получить ID пользователя.');
      }
    } else {
      throw Exception('Неверный адрес электронной почты или пароль.');
    }
  }


  // Метод выхода из системы
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_loggedInKey);
    // Сброс информации о текущем пользователе
    _currentUser = null;
    _currentUserId = null;
  }

  // Получение имени текущего пользователя
  static String? getCurrentUserName() {
    return _currentUser;
  }

  // Получение ID текущего пользователя
  static String? getCurrentUserId() {
    return _currentUserId;
  }
}
