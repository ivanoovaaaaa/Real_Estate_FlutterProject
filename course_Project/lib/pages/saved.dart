import 'dart:typed_data';
import 'package:course_project/pages/filter.dart';
import 'package:course_project/pages/places_explain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:course_project/utils/color.dart';
import 'package:course_project/utils/gap.dart';
import 'package:course_project/models/property.dart';
import 'package:course_project/data/DBHelper.dart';


class Saved extends StatefulWidget {

  const Saved({Key? key}) : super(key: key);

  @override
  _SavedState createState() => _SavedState();


}

class _SavedState extends State<Saved> {
  RangeValues selectedAreaValues = RangeValues(0, 1000);
  RangeValues selectedCostValues = RangeValues(0, 100000);
  RangeValues selectedYearBuiltValues = RangeValues(1900, 2025);

  String? selectedCondition;
  void _updateCondition(String? condition) {
    setState(() {
      selectedCondition = condition;
    });
  }
  List<String> conditions = ['Новый ремонт', 'Советский ремонт', 'Без ремонта'];
  List<String> selectedRentTypes = []; // Выбранные типы недвижимости
  List<String> rentTypes = [
    'Квартира', 'Комната', 'Новостройка', 'Дом', 'Коттедж', 'Агроусадьба'
  ];
  List<int> selectedRooms = []; // Выбранные количество комнат
  List<String> districts = [
    'Центральный район', 'Советский район', 'Первомайский район',
    'Партизанский район', 'Заводской район', 'Ленинский район',
    'Октябрьский район', 'Московский район', 'Фрунзенский район',
  ];
  bool isSuitableForChildren = false;
  bool isPetsAllowed = false;

  void updateProperties(List<Property> filteredProperties) {
    setState(() {
      properties = filteredProperties;
    });
  }


  final searchInput = TextEditingController();
  final searchFocus = FocusNode();
  List<Property> properties = [];
  List<Property> filteredProperties = [];

  // Метод для выбора комнат
  void _toggleRoomSelection(int roomNumber) {
    setState(() {
      if (selectedRooms.contains(roomNumber)) {
        selectedRooms.remove(roomNumber);
      } else {
        selectedRooms.add(roomNumber);
      }
    });
  }



  @override
  void dispose() {
    super.dispose();
    searchInput.dispose();
    searchFocus.dispose();
  }

  List<String> selectedPropertyTypes = [];
  List<String> propertyTypeList = ['Квартира', 'Комната', 'Новостройка','Дом', 'Коттедж', 'Агроусадьба'];
  List<String> districtList = ['Центральный район',
    'Советский район',
    'Первомайский район',
    'Партизанский район',
    'Заводской район',
    'Ленинский район',
    'Октябрьский район',
    'Московский район',
    'Фрунзенский район',];
  String selectedDistrict = '';


  // Метод для фильтрации списка объявлений по улице
  List<Property> filterPropertiesByStreet(String street) {
    return properties.where((property) => property.street.toLowerCase().contains(street.toLowerCase())).toList();
  }

  List<Property> filterProperties(
      List<String> selectedRentTypes,
      List<int> selectedRooms,
      String? selectedCondition,
      RangeValues areaValues,
      RangeValues costValues,
      RangeValues yearBuiltValues,
      ) {
    print("Selected Rent Types: $selectedRentTypes");
    print("Selected Rooms: $selectedRooms");
    print("Selected Condition: $selectedCondition");
    print("Area Values: $areaValues");
    print("Cost Values: $costValues");
    print("Year Built Values: $yearBuiltValues");

    filteredProperties = properties.where((property) {
      bool matchesRentType = selectedRentTypes.isEmpty || selectedRentTypes.contains(property.rentType);
      bool matchesRooms = selectedRooms.isEmpty || selectedRooms.contains(property.numRooms);
      bool matchesCondition = selectedCondition == null || property.condition == selectedCondition;
      bool matchesArea = property.area >= areaValues.start && property.area <= areaValues.end;
      bool matchesCost = property.cost >= costValues.start && property.cost <= costValues.end;
      bool matchesYearBuilt = property.yearBuilt >= yearBuiltValues.start && property.yearBuilt <= yearBuiltValues.end;
      return matchesRentType && matchesRooms && matchesCondition && matchesArea && matchesCost && matchesYearBuilt;
    }).toList();

    print("Filtered Properties:");
    filteredProperties.forEach((property) {
      print("Title: ${property.title}, Rent Type: ${property.rentType}, Rooms: ${property.numRooms}");
    });

    return filteredProperties;
  }







  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      backgroundColor: AppColors.BColor,
      appBar: AppBar(
        backgroundColor: AppColors.BColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Expanded(
              child: Container(
                width: 290,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.search, color: AppColors.textPrimary, size: 22,),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchInput,
                        focusNode: searchFocus,
                        decoration: InputDecoration(
                          hintText: 'Поиск по улице',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(isWidth: true, isHeight: false, width: width * 0.03),
            GestureDetector(
              onTap: () async {

                await FilterDialog.show(context, (areaValues, costValues, yearBuiltValues, selectedRentTypes, selectedRooms, selectedCondition, isSuitableForChildren, isPetsAllowed) async {

                  filteredProperties = filterProperties(selectedRentTypes, selectedRooms, selectedCondition, areaValues, costValues, yearBuiltValues);
                  // Обновляем состояние properties с учетом фильтрованных свойств
                  setState(() {
                    selectedAreaValues = areaValues;
                    selectedCostValues = costValues;
                    selectedYearBuiltValues = yearBuiltValues;
                    filteredProperties = filterProperties(selectedRentTypes, selectedRooms, selectedCondition, areaValues, costValues, yearBuiltValues);
                    updateProperties(filteredProperties); // Обновляем виджет с новыми данными
                  });
                },
                    areaValues: selectedAreaValues,
                    costValues: selectedCostValues,
                    yearBuiltValues: selectedYearBuiltValues,

                    selectedRooms: selectedRooms,
                    selectedRentTypes:selectedRentTypes,
                    selectedCondition: selectedCondition,
                    isPetsAllowed:isPetsAllowed,
                    isSuitableForChildren:isSuitableForChildren,
                    onUpdateCondition: _updateCondition
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.Black),
                ),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.list, size: 18.0, color: AppColors.primaryColor,),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(isWidth: false, isHeight: true, height: height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: FutureBuilder<List<Property>>(
                  future: DatabaseHelper().getFavoriteProperties(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      properties = snapshot.data ?? [];
                      List<Property> displayProperties = searchInput.text.isNotEmpty ? filterPropertiesByStreet(searchInput.text) : properties;
                      // Используйте отфильтрованные данные, если они есть
                      if (filteredProperties.isNotEmpty) {
                        displayProperties = filteredProperties;
                      }
                      if (properties.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/notfound.jpg'), // Замените путь к изображению на свой
                            SizedBox(height: 20),
                            Text(
                              'Вы еще не добавили ни одно объявление в избранное',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }
                      else if (displayProperties.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/notfound.jpg'), // Замените путь к изображению на свой
                            SizedBox(height: 20),
                            Text(
                              'Нет доступных объявлений',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }
                      else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: displayProperties.map((property) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            destinationScreen(
                                                property: property),
                                      ),

                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 15),
                                        width: double.infinity,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius
                                                    .circular(20.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 7),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 210,),
                                                    Text(
                                                      property.title,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight
                                                            .bold,
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
                                                        const SizedBox(
                                                            width: 5.0),
                                                        FutureBuilder<double>(
                                                          future: property.id !=
                                                              null
                                                              ? DatabaseHelper()
                                                              .getAverageRatingForProperty(
                                                              property.id!)
                                                              : Future.value(
                                                              0.0),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return CircularProgressIndicator();
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot
                                                                      .error}');
                                                            } else {
                                                              double averageRating = snapshot
                                                                  .data ?? 0.0;
                                                              return FutureBuilder<
                                                                  int>(
                                                                future: property
                                                                    .id != null
                                                                    ? DatabaseHelper()
                                                                    .getReviewCountForProperty(
                                                                    property
                                                                        .id!)
                                                                    : Future
                                                                    .value(0),
                                                                builder: (
                                                                    context,
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
                                                                        0;
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
                                              height: 200,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(10.0),
                                              ),
                                              child: FutureBuilder<Uint8List?>(
                                                future: property.id != null
                                                    ? DatabaseHelper()
                                                    .getFirstPhotoForProperty(
                                                    property.id!)
                                                    : null,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child: CircularProgressIndicator());
                                                  } else
                                                  if (snapshot.hasError) {
                                                    return Center(child: Text(
                                                        'Error: ${snapshot
                                                            .error}'));
                                                  } else
                                                  if (snapshot.data != null) {
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(20.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .all(10),
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
                                                      borderRadius: BorderRadius
                                                          .circular(20.0),
                                                      child: Container(
                                                        color: Colors.grey,
                                                        height: 160.0,
                                                        width: 180.0,
                                                        child: Center(
                                                            child: Text(
                                                                'No Image')),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}


