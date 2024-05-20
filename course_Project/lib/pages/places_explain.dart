import 'package:course_project/AuthManager.dart';
import 'package:course_project/pages/advEdit.dart';
import 'package:course_project/pages/bottomnavi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:course_project/utils/button.dart';
import 'package:course_project/utils/color.dart';
import 'package:course_project/models/property.dart';
import 'package:course_project/models/user.dart';
import 'package:course_project/models/review.dart';
import 'package:course_project/data/DBHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:course_project/pages/ReviewDialog.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatelessWidget {
  final List<Uint8List?> images;
  final int initialIndex;

  GalleryScreen({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryColor,),
          color: Colors.black,
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Align(
                  alignment: Alignment.center,
                  child: PhotoViewGallery.builder(
                    itemCount: images.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: MemoryImage(images[index]!),
                      );
                    },
                    scrollPhysics: const BouncingScrollPhysics(),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    pageController: PageController(initialPage: initialIndex),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}



class destinationScreen extends StatefulWidget {

  final Property property;

  destinationScreen({required this.property});


@override
  State<destinationScreen> createState() => _destinationScreenState();

}

class _destinationScreenState extends State<destinationScreen> {
  late Future<User> _ownerDetails;
  void _launchPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    Uri uri = Uri.parse(url); // Создание объекта Uri из строки URL
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future <void> _removePropertyAndReturn(BuildContext context) async {

    await DatabaseHelper().removeProperty(widget.property.id!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomNavi()),
    );


  }


  Future<void> _addToFavorites() async {
    // Получаем экземпляр базы данных
    Database db = await DatabaseHelper().database;
    // Создаем запись в таблице избранных
    await db.insert('Favorites', {
      'UserId': AuthManager.getCurrentUserId(),
      'PropertyId': widget.property.id,
      'AddingDate': DateTime.now().toString(),
    });
  }

  Future<void> _removeFromFavorites() async {
    // Получаем экземпляр базы данных
    Database db = await DatabaseHelper().database;
    // Удаляем запись из таблицы избранных
    await db.delete(
      'Favorites',
      where: 'UserId = ? AND PropertyId = ?',
      whereArgs: [AuthManager.getCurrentUserId(), widget.property.id],
    );
  }
  bool _isFavorite = false;
  @override
  void initState() {
    super.initState();
    _ownerDetails =  DatabaseHelper().getOwnerDetails(widget.property.ownerId);
    _checkFavoriteStatus();
  }
  Future<void> _checkFavoriteStatus() async {
    // Проверяем, что текущий пользователь не является владельцем объявления
    if (widget.property.ownerId.toString() != AuthManager.getCurrentUserId()) {
      bool isFavorite = await DatabaseHelper().isPropertyInFavorites(
          int.parse(AuthManager.getCurrentUserId()!), // Получаем ID текущего пользователя
          widget.property.id! // Получаем ID текущего объявления
      );

      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [

                // Ваш виджет
                Container(
                  height: 330,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<Uint8List?>>(
                    future: DatabaseHelper().getAllPhotosForProperty(widget.property.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final List<Uint8List?> images = snapshot.data ?? [];
                        if (images.isNotEmpty) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GalleryScreen(
                                    images: images,
                                    initialIndex: 0,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'property_image_${widget.property.id}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.memory(
                                  images.first!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                              child: Text('No Images'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),






                //adding back arrow button
                Padding(
                    padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:  AppColors.iconbg,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child:  Center(
                            child:  IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavi(),
                                  ),
                                );

                              },
                              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryColor,),
                              color: Colors.black,
                              iconSize: 20.0,
                            ),
                          ),
                        ),
                        AuthManager.getCurrentUserName() == 'admin' || ( int.parse((AuthManager.getCurrentUserId())!) == widget.property.ownerId && widget.property.status == 'В РАССМОТРЕНИИ')
 ?     Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconbg,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    // Открываем диалоговое окно при нажатии на корзину
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Удалить объявление?"),
                                          content: Text("Вы действительно хотите удалить это объявление?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Пользователь выбрал "Да", удаляем объявление и возвращаемся на предыдущий экран
                                                _removePropertyAndReturn(context);
                                              },
                                              child: Text("Да"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Пользователь выбрал "Отмена", закрываем диалоговое окно
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Отмена"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.trash,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                ),

                              ),
                            ),


                            SizedBox(width: 10), // Промежуток между кнопками
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:  AppColors.iconbg,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child:  Center(
                                child:  IconButton(
                                  onPressed: () {
                                    EditPropertyDialog.show(context, widget.property, () {
                                      setState(() {}); // Вызов setState после закрытия диалогового окна
                                    });
                                  },


                                  icon: FaIcon(
                                    FontAwesomeIcons.pen, // Иконка для второй кнопки
                                    size: 18.0,
                                    color: AppColors.primaryColor, // Изменяем цвет иконки
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ):Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:  AppColors.iconbg,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child:  Center(
                            child:  IconButton(
                              onPressed: () async {
                                // Проверяем, что текущий пользователь не является владельцем объявления
                                if (widget.property.ownerId.toString() != AuthManager.getCurrentUserId()) {
                                  if (_isFavorite) {
                                    await _removeFromFavorites();
                                  } else {
                                    await _addToFavorites();
                                  }

                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                } else {
                                  // Владельцу объявления нельзя добавить его в избранное
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Вы не можете добавить своё объявление в избранное')),
                                  );
                                }
                              },

                              icon: FaIcon(
                                _isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                size: 18.0,
                                color: _isFavorite ? Colors.red : AppColors.primaryColor, // Изменяем цвет иконки
                              ),

                            ),
                          ),
                        ) ,


                      ],
                    )


                ),

              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //adding and Rating function
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.property.cost} ${widget.property.type == "Долгосрочная" ? "руб/месяц" : "руб/сутки"}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 15.0,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 5.0),
                          FutureBuilder<double>(
                            future: widget.property.id != null ? DatabaseHelper().getAverageRatingForProperty(widget.property.id!) : Future.value(0.0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                double averageRating = snapshot.data ?? 0.0; // Если данные отсутствуют, устанавливаем рейтинг по умолчанию 0.0
                                return FutureBuilder<int>(
                                  future: widget.property.id != null ? DatabaseHelper().getReviewCountForProperty(widget.property.id!) : Future.value(0),
                                  builder: (context, reviewSnapshot) {
                                    if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (reviewSnapshot.hasError) {
                                      return Text('Error: ${reviewSnapshot.error}');
                                    } else {
                                      int reviewCount = reviewSnapshot.data ?? 0; // Если данные отсутствуют, устанавливаем количество отзывов по умолчанию 0
                                      return Row(
                                        children: [
                                          Text(
                                            '${averageRating.toStringAsFixed(1)}',
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.black45,
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            'Отзывов: $reviewCount',
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),


                    ],
                  ),
                  const SizedBox(
                    height: 0.0,
                  ),

                  Text(
                    '${widget.property.area} м2',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    '${widget.property.street} ${widget.property.house} ${widget.property.ward}',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),

                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    '${widget.property.district} район',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),

                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    widget.property.condition,
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    widget.property.details,
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),

                  ),
 const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Дополнительно',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top:10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.building,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.property.rentType == "Квартира" ||
                                        widget.property.rentType == "Новостройка" ||
                                        widget.property.rentType == "Комната"
                                        ? "${widget.property.floor} этаж"
                                        : "кол-во этажей ${widget.property.floor}",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.bath,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${widget.property.bathroomType}'),
                                ],
                              ),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.home,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${widget.property.numRooms} комнат'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.child,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.property.suitableForChildren == 1
                                        ? "можно с детьми"
                                        : "без детей",
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendar,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${widget.property.yearBuilt}'),
                                ],
                              ),
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.paw,
                                    size: 18.0,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text( widget.property.petsAllowed == 1
                                      ? "можно с животными"
                                      : "без животных",),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.property.kitchenOptions != null)
                    Text(
                   'На кухне: ${widget.property.kitchenOptions}',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  if (widget.property.bathroomOptions != null)
                    Text(
                    'В ванной: ${widget.property.bathroomOptions}',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  if (widget.property.householdOptions != null)
                    Text(
                    'В доме: ${widget.property.householdOptions}',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black45
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Владелец',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color:  AppColors.iconbg,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              FontAwesomeIcons.user, // выберите нужную иконку из библиотеки
                              size: 40, // установите размер иконки по вашему усмотрению
                              color: AppColors.primaryColor, // установите цвет иконки по вашему усмотрению
                            ),

                          ),
                          const SizedBox(
                            width: 20,
                          ),

                          FutureBuilder<User>(
                            future: _ownerDetails,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                User owner = snapshot.data!;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('${owner.firstName} ${owner.lastName}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text('${owner.phone}'),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:  AppColors.iconbg,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child:  Center(
                              child:FutureBuilder<User>(
                                future: _ownerDetails,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    User owner = snapshot.data!;
                                    return IconButton(
                                      onPressed: () => _launchPhoneCall(owner.phone),
                                      icon: const FaIcon(
                                        FontAwesomeIcons.phone,
                                        size: 18.0,
                                        color: AppColors.primaryColor,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                          ),

                          const SizedBox(
                            width: 10,
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FutureBuilder<List<Review>>(
                    future: widget.property.id != null ? DatabaseHelper().getAllRev(widget.property.id!) : Future.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Review> reviews = snapshot.data ?? [];
                        return Column(
                          children: [
                            SizedBox(height: 20.0),

                            Text(
                              'Отзывы',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10.0),

                            // Ваш виджет
                            FutureBuilder<List<Review>>(
                              future: DatabaseHelper().getAllRev(widget.property.id!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Ошибка: ${snapshot.error}');
                                } else {
                                  List<Review> reviews = snapshot.data!;
                                  if (reviews.isEmpty) {
                                    return Column(
                                      children: [

                                        SizedBox(height: 10.0),
                                        // Ваш виджет с изображением и подписью, например:
                                        Image.asset('assets/notfound.jpg'),
                                        SizedBox(height: 10.0),
                                        Text(
                                          'Пока нет отзывов',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [

                                        SizedBox(height: 10.0),
                                        CarouselSlider(
                                          options: CarouselOptions(
                                            height: 200.0,
                                            enlargeCenterPage: true,
                                          ),
                                          items: reviews.map((review) {
                                            return FutureBuilder<User>(
                                              future: DatabaseHelper().getUser(review.reviewerId),
                                              builder: (context, userSnapshot) {
                                                if (userSnapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (userSnapshot.hasError) {
                                                  return Text('Ошибка: ${userSnapshot.error}');
                                                } else {
                                                  User reviewer = userSnapshot.data!;
                                                  String reviewerName = '${reviewer.firstName} ${reviewer.lastName}';
                                                  return Builder(
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(20.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Отзыв от $reviewerName',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0,
                                                                ),
                                                              ),
                                                              SizedBox(height: 10.0),
                                                              Text(
                                                                '${review.comment}',
                                                                style: TextStyle(fontSize: 14.0),
                                                              ),
                                                              SizedBox(height: 10.0),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.star,
                                                                    size: 15.0,
                                                                    color: Colors.yellow,
                                                                  ),
                                                                  Text(
                                                                    ' ${review.rating}',
                                                                    style: TextStyle(fontSize: 14.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              if (AuthManager.getCurrentUserName() == 'admin') // Проверяем, является ли пользователь админом
                                                                IconButton(
                                                                  onPressed: () async {
                                                                    // Удаление комментария из базы данных
                                                                    await DatabaseHelper().deleteReview(review.reviewId!);

                                                                    // Перезагрузка виджета или обновление состояния для удаления удаленного комментария из списка
                                                                    setState(() {});
                                                                  },
                                                                  icon: Icon(Icons.delete), // Иконка удаления
                                                                ),
                                                              SizedBox(height: 20,)
                                                            ],

                                                          ),

                                                        ),

                                                      );

                                                    },

                                                  );

                                                }
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 20,)

                                      ],
                                    );
                                  }
                                }
                              },
                            ),





                            SizedBox(height: 20.0),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),


            AuthManager.getCurrentUserName() != 'admin' ? RoundButton(
              title: "Добавить отзыв",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                  return ReviewDialog(propertyId: widget.property.id!);
                  },
                );
              },
            )
                : Container(
              height: 20,
            )

    ],
    ),
    )
    );
  }
}



