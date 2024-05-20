import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:course_project/models/property.dart';
import 'package:course_project/data/DBHelper.dart';
import 'package:course_project/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:course_project/AuthManager.dart';
import 'package:sqflite/sqflite.dart';


class AddPropertyDialog extends StatefulWidget {
  @override
  _AddPropertyDialogState createState() => _AddPropertyDialogState();
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPropertyDialog();
      },
    );
  }
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  int selectedRoom = -1; // Изначально ни одна комната не выбрана




  Uint8List? loadedImageBytes;

  List<Uint8List?> imageBytesList = List.generate(10, (_) => null);
  Future<void> _openGallery(int index) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageData = await pickedImage.readAsBytes();
      setState(() {
        loadedImageBytes = Uint8List.fromList(imageData);
        imageBytesList[index - 1] = loadedImageBytes;
      });
    }
  }
File? _image;
final picker = ImagePicker();

Future getImage() async{
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if(pickedImage!=null){
      _image=File(pickedImage.path);

    }
    else{
      print("No image");
    }
  });
}


  String? selectedCondition;
  List<String> conditions = ['Новый ремонт', 'Советский ремонт', 'Без ремонта'];

  String? selectedRentType;
  List<String> rentTypes = ['Квартира', 'Комната', 'Новостройка','Дом', 'Коттедж', 'Агроусадьба'];

  int? selectedYear;
  List<int> years = List.generate(2025 - 1900, (index) => 1900 + index);

  String? selectedDistrict;
  List<String> districts = [
    'Центральный район',
    'Советский район',
    'Первомайский район',
    'Партизанский район',
    'Заводской район',
    'Ленинский район',
    'Октябрьский район',
    'Московский район',
    'Фрунзенский район',
  ];


  List<String> typesBath = ['Совместный', 'Раздельный', 'Два', "Три"]; // Значения для выбора
  String selectedValue = ''; // Выбранное значение
  Color defaultColor = Colors.grey; // Цвет по умолчанию
  Color selectedColor = Colors.blue; // Цвет для выбранного элемента

  List<String> selectedValuesBath = [];
  List<String> selectedValuesKitchen = [];
  List<String> selectedValuesHouse = [];
  List<String> InBathRoom = ['Джакузи', 'Душевая кабина', 'Ванна', "Стиральная машина", 'Фен', "Комплект полотенец"];
  List<String> InKitchen = ['Холодильник', 'СВЧ-печь', 'Посудомоечная машина', "Посуда/столовые приборы", 'Кофеварка', 'Электрическая плита', "Газовая плита"];
  List<String> InHouse = ['Wi-Fi', 'Телевизор', 'Мебель', 'Телефон', 'Кондиционер', 'Утюг',"Пылесос"];

  String? selectedType;
  List<String> types = ['Долгосрочная', 'На сутки'];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController numRoomsController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController rentTypecontroller = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController houseOptionController = TextEditingController();
  final TextEditingController bathController = TextEditingController();
  final TextEditingController kitchenController = TextEditingController();
  final TextEditingController bathTypeController = TextEditingController();


  String? currentId = AuthManager.getCurrentUserId();
  String? currentUserName = AuthManager.getCurrentUserName();



  bool isSuitableForChildren = false;
  bool isPetsAllowed = false;

  void _addToDatabase() async {
      Database db = await DatabaseHelper().database;
      // Extracting data from UI elements

      String title = titleController.text;
      String details = detailsController.text;
      double area = double.parse(areaController.text);
      int numRooms = selectedRoom;
      int ownerId = int.parse(currentId!);
      String street = streetController.text;
      String district = districtController.text;
      String rentType = rentTypecontroller
          .text; // You need to define where this value comes from
      int house = int.parse(houseController.text);
      String ward = wardController.text;
      double cost = double.parse(costController.text);
      int floor = int.parse(floorController.text);
      String type = typeController.text;
      int yearBuilt = int.parse(yearBuiltController.text);
      String condition = conditionController
          .text; // You need to define where this value comes from
      String status = AuthManager.getCurrentUserName() == "admin"
          ? "ОПУБЛИКОВАНО"
          : "В РАССМОТРЕНИИ"; // You need to define where this value comes from
      int suitableForChildren = isSuitableForChildren ? 1 : 0;
      String bathroomType = bathTypeController
          .text; // You need to define where this value comes from
      int petsAllowed = isPetsAllowed ? 1 : 0;
      String kitchenOptions = kitchenController
          .text; // You need to define where this value comes from
      String bathroomOptions = bathController
          .text; // You need to define where this value comes from
      String householdOptions = houseOptionController
          .text; // You need to define where this value comes from

      // Creating a Property object
      Property property = Property(
        title: title,
        details: details,
        area: area,
        numRooms: numRooms,
        ownerId: ownerId,
        street: street,
        district: district,
        rentType: rentType,
        house: house,
        ward: ward,
        cost: cost,
        floor: floor,
        type: type,
        yearBuilt: yearBuilt,
        condition: condition,
        status: status,
        suitableForChildren: suitableForChildren,
        bathroomType: bathroomType,
        petsAllowed: petsAllowed,
        kitchenOptions: kitchenOptions,
        bathroomOptions: bathroomOptions,
        householdOptions: householdOptions,
      );


      int propertyId = await DatabaseHelper().insertProperty(db, property);

      // Вставка фотографий в базу данных
      for (int i = 0; i < imageBytesList.length; i++) {
        if (imageBytesList[i] != null) {
          await DatabaseHelper().insertPhoto(
              db, imageBytesList[i]!, propertyId);
        } else {
          print(
              'Предупреждение: Попытка вставить NULL значение в столбец Image');
          // Handle accordingly
        }
      }


      // Close the dialog
      Navigator.of(context).pop();

  }
  Future<void> _showImageActionDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выберите действие'),
          actions: <Widget>[
            TextButton(
              child: Text('Удалить'),
              onPressed: () {
                // Удалить изображение
                setState(() {
                  imageBytesList[index] = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Загрузить другое'),
              onPressed: () {
                // Загрузить другое изображение
                _openGallery(index + 1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool validateForm() {
    if (titleController.text.isEmpty ||
        detailsController.text.isEmpty ||
        areaController.text.isEmpty ||
        numRoomsController.text.isEmpty ||
        districtController.text.isEmpty ||
        streetController.text.isEmpty ||
        houseController.text.isEmpty ||
        floorController.text.isEmpty ||
        rentTypecontroller.text.isEmpty ||
        costController.text.isEmpty ||
        typeController.text.isEmpty ||
        yearBuiltController.text.isEmpty ||
        conditionController.text.isEmpty ||
        bathTypeController.text.isEmpty ||
        kitchenController.text.isEmpty ||
        bathController.text.isEmpty ||
        houseOptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Все поля должны быть заполнены.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }

    int? floor = int.tryParse(floorController.text);
    if (floor == null || floor < 1 || floor > 30) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Этаж должен быть в диапазоне от 1 - 30'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }

    double? area = double.tryParse(areaController.text);
    if (area == null || area < 10 || area > 500) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Площадь должна быть в диапазоне от 10 до 500 кв.м.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }

    double? cost = double.tryParse(costController.text);
    if (cost == null || cost < 10 || cost > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Стоимость должна быть в диапазоне от 10 до 5000 бел. руб.')),
      );

      return false;
    }

    int? houseNumber = int.tryParse(houseController.text);
    if (houseNumber == null || houseNumber < 1 || houseNumber > 150) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Номер дома должен быть в диапазоне от 1 до 150.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Карусель с иконками
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (index < imageBytesList.length && imageBytesList[index] != null) {
                          _showImageActionDialog(context, index);
                        } else {
                          _openGallery(index + 1);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 80,
                        height: 80,
                        color: Colors.grey.withOpacity(0.3),
                        child: imageBytesList[index] != null
                            ? Image.memory(imageBytesList[index]!)
                            : Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.primaryColor),
                      ),
                    );
                  },
                ),
              ),

              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Заголовок объявления'),
              ),
              TextField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
              TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: 'Площадь, кв м'),
                keyboardType: TextInputType.number,
              ),
              Text(
                'Количество комнат',
                style: TextStyle(fontSize: 16, // Размер шрифта
                  color: Colors.black54), // Цвет текста
              ),
              Row(
                children: [
                  for (int i = 1; i <= 9; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRoom = i;
                          numRoomsController.text = i.toString();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedRoom == i ? Colors.blue : Colors.grey,
                        ),
                        child: Text(
                          i.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
          DropdownButtonFormField<String>(
            value: selectedDistrict,
            onChanged: (String? value) {
              setState(() {
                selectedDistrict = value;
                districtController.text = value ?? '';
              });
            },
            decoration: InputDecoration(labelText: 'Район'),
            items: districts.map((String district) {
              return DropdownMenuItem<String>(
                value: district,
                child: Text(district),
              );
            }).toList(),
          ),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Улица'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: houseController,
                      decoration: InputDecoration(labelText: 'Номер дома'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: wardController,
                      decoration: InputDecoration(labelText: 'Корпус'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child:   TextField(
                    controller: floorController,
                    decoration: InputDecoration(labelText: 'Этаж'),
                    keyboardType: TextInputType.number,
                  ),)
                ],
              ),

              DropdownButtonFormField<String>(
                value: selectedRentType,
                onChanged: (String? value) {
                  setState(() {
                    selectedRentType = value;
                    rentTypecontroller.text = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Тип недвижимости'),
                items: rentTypes.map((String rentTypes) {
                  return DropdownMenuItem<String>(
                    value: rentTypes,
                    child: Text(rentTypes),
                  );
                }).toList(),
              ),


              TextField(
                controller: costController,
                decoration: InputDecoration(labelText: 'Стоимость, бел. руб.'),
                keyboardType: TextInputType.number,
              ),
            
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (String? value) {
                  setState(() {
                    selectedType = value;
                    typeController.text = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Тип'),
                items: types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),


              DropdownButtonFormField<int>(
                value: selectedYear,
                onChanged: (int? value) {
                  setState(() {
                    selectedYear = value;
                    yearBuiltController.text = value?.toString() ?? ''; // Convert int to String
                  });
                },
                decoration: InputDecoration(labelText: 'Год постройки'),
                items: years.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
              ),


              DropdownButtonFormField<String>(
                value: selectedCondition,
                onChanged: (String? value) {
                  setState(() {
                    selectedCondition = value;
                    conditionController.text = value ?? '';
                  });
                },
                decoration: InputDecoration(labelText: 'Состояние'),
                items: conditions.map((String condition) {
                  return DropdownMenuItem<String>(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
              ),

              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isSuitableForChildren,
                        onChanged: (value) {
                          setState(() {
                            isSuitableForChildren = value!;
                          });
                        },
                      ),
                      Text('Можно с детьми', style: TextStyle(fontSize: 16, // Размер шрифта
                        color: Colors.black,),),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isPetsAllowed,
                        onChanged: (value) {
                          setState(() {
                            isPetsAllowed = value!;
                          });
                        },
                      ),
                      Text('Можно с домашними животными', style: TextStyle(fontSize: 16, // Размер шрифта
                        color: Colors.black,), // Цвет текста
        ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Тип санузла',
                    style: TextStyle(fontSize: 16, // Размер шрифта
                      color: Colors.black,), // Цвет текста
                  ),
                ),
              ),
              SizedBox(height: 10),
    Padding(
    padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
    child: Align(
    alignment: Alignment.centerLeft,
    child:
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: typesBath.map((value) {
                  bool isSelected = selectedValue == value;
                  return GestureDetector(
                    onTap: () {
                      // Действие при выборе значения
                      setState(() {
                        selectedValue = value;
                      });
                      bathTypeController.text = selectedValue;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : defaultColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
    ),
    ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'На кухне',
                    style: TextStyle(fontSize: 16, // Размер шрифта
                      color: Colors.black,), // Цвет текста
                  ),
                ),
              ),

              SizedBox(height: 10),
    Padding(
    padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
    child: Align(
    alignment: Alignment.centerLeft,
    child:
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: InKitchen.map((value) {
                  bool isSelected = selectedValuesKitchen.contains(value);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedValuesKitchen.remove(value);
                        } else {
                          selectedValuesKitchen.add(value);
                        }
                        kitchenController.text = selectedValuesKitchen.join(', ');
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : defaultColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
    ),
    ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'В ванной',
                    style: TextStyle(fontSize: 16, // Размер шрифта
                      color: Colors.black,), // Цвет текста
                  ),
                ),
              ),
              SizedBox(height: 10),

    Padding(
    padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
    child: Align(
    alignment: Alignment.centerLeft,
    child:
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: InBathRoom.map((value) {
                  bool isSelected = selectedValuesBath.contains(value);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedValuesBath.remove(value);
                        } else {
                          selectedValuesBath.add(value);
                        }
                        bathController.text = selectedValuesBath.join(', ');
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : defaultColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
    ),
    ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'В доме',
                    style: TextStyle( fontSize: 16, // Размер шрифта
                      color: Colors.black, ), // Цвет текста
                  ),
                ),
              ),
              SizedBox(height: 10),

    Padding(
    padding: const EdgeInsets.only(left: 5.0), // Отступ слева для текста
    child: Align(
    alignment: Alignment.centerLeft,
    child:
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: InHouse.map((value) {
                  bool isSelected = selectedValuesHouse.contains(value);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedValuesHouse.remove(value);
                        } else {
                          selectedValuesHouse.add(value);
                        }
                        houseOptionController.text = selectedValuesHouse.join(', ');
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : defaultColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
    ),
    ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      if (validateForm()) {
                        _addToDatabase();
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor, // Background color
                      textStyle: TextStyle(
                        color: Colors.white, // Text color
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 120, // Ширина кнопки
                      height: 50, // Высота кнопки
                      child: Center(
                        child: Text(
                          'Добавить',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor, // Background color
                      textStyle: TextStyle(
                        color: Colors.white, // Text color
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 120, // Ширина кнопки
                      height: 50, // Высота кнопки
                      child: Center(
                        child: Text(
                          'Отмена',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}





