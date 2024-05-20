import 'package:course_project/pages/places_explain.dart';
import 'package:flutter/material.dart';
import 'package:course_project/models/property.dart';
import 'package:course_project/data/DBHelper.dart';
import 'dart:typed_data';
import 'package:course_project/utils/color.dart';


class Purpose extends StatefulWidget {
  const Purpose({Key? key}) : super(key: key);

  @override
  _PurposeState createState() => _PurposeState();
}

class _PurposeState extends State<Purpose> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50), // Отступы сверху и снизу
      child: FutureBuilder<List<Property>>(
        future: DatabaseHelper().getPurposeProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Property>? properties = snapshot.data;
            if (properties!.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120),
                  Image.asset('assets/notfound.jpg'), // Замените путь к изображению на свой
                  SizedBox(height: 20),
                  Text(
                    'Нет предложенных объявлений!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
            else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // Растягиваем элементы по ширине экрана
                  children: properties!.map((property) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      // Отступы между элементами списка
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  destinationScreen(property: property),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              width: double.infinity,
                              // Растягиваем контейнер на всю ширину экрана
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 7),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          const SizedBox(height: 210,),
                                          Text(
                                            property.title,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Text(
                                            property.details,
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 8.0,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 15.0,
                                                color: Colors.yellow,
                                              ),
                                              const SizedBox(width: 5.0),
                                              FutureBuilder<double>(
                                                future: property.id != null
                                                    ? DatabaseHelper()
                                                    .getAverageRatingForProperty(
                                                    property.id!)
                                                    : Future.value(0.0),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot
                                                            .error}');
                                                  } else {
                                                    double averageRating = snapshot
                                                        .data ??
                                                        0.0; // Если данные отсутствуют, устанавливаем рейтинг по умолчанию 0.0
                                                    return FutureBuilder<int>(
                                                      future: property.id !=
                                                          null
                                                          ? DatabaseHelper()
                                                          .getReviewCountForProperty(
                                                          property.id!)
                                                          : Future.value(0),
                                                      builder: (context,
                                                          reviewSnapshot) {
                                                        if (reviewSnapshot
                                                            .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return CircularProgressIndicator();
                                                        } else
                                                        if (reviewSnapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${reviewSnapshot
                                                                  .error}');
                                                        } else {
                                                          int reviewCount = reviewSnapshot
                                                              .data ??
                                                              0; // Если данные отсутствуют, устанавливаем количество отзывов по умолчанию 0
                                                          return Row(
                                                            children: [
                                                              Text(
                                                                'Рейтинг: ${averageRating
                                                                    .toStringAsFixed(
                                                                    1)}',
                                                                style: const TextStyle(
                                                                  fontSize: 10.0,
                                                                  color: Colors
                                                                      .black45,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10.0),
                                                              Text(
                                                                'Отзывов: $reviewCount',
                                                                style: const TextStyle(
                                                                  fontSize: 10.0,
                                                                  color: Colors
                                                                      .black45,
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
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    // Изменено на double.infinity, чтобы контейнер растягивался на всю ширину экрана
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: FutureBuilder<Uint8List?>(
                                      future: property.id != null
                                          ? DatabaseHelper()
                                          .getFirstPhotoForProperty(
                                          property.id!)
                                          : null,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text(
                                              'Error: ${snapshot.error}'));
                                        } else if (snapshot.data != null) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(20.0),
                                                child: Image.memory(
                                                  snapshot.data!,
                                                  height: 160.0,
                                                  width: 180.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            child: Container(
                                              color: Colors.grey,
                                              // Замените на цвет по вашему усмотрению
                                              height: 160.0,
                                              width: 180.0,
                                              child: Center(child: Text(
                                                  'No Image')), // Замените на текст по вашему усмотрению
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await DatabaseHelper().approveProperty(
                                        property.id!);
                                    // Обновляем интерфейс
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    // Background color
                                    textStyle: TextStyle(
                                      color: Colors.white, // Text color
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 140, // Ширина кнопки
                                    height: 50, // Высота кнопки
                                    child: Center(
                                      child: Text(
                                        'Одобрить',
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                                ElevatedButton(
                                  onPressed: () async {
                                    await DatabaseHelper().deleteProperty(
                                        property.id!);
                                    // Обновляем интерфейс
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    // Background color
                                    // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  child: SizedBox(
                                    width: 140, // Ширина кнопки
                                    height: 50, // Высота кнопки
                                    child: Center(
                                      child: Text(
                                        'Удалить',
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}



