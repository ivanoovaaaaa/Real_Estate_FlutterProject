import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:course_project/models/property.dart';
import 'package:course_project/data/DBHelper.dart';
import 'package:course_project/pages/bottomnavi.dart';
import 'package:course_project/pages/home.dart';
import 'package:course_project/pages/places_explain.dart';
import 'package:course_project/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:course_project/AuthManager.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class EditPropertyDialog extends StatefulWidget {
  final Property property;

  EditPropertyDialog({required this.property});

  @override
  _EditPropertyDialogState createState() => _EditPropertyDialogState(onClose: () {});

  static Future<void> show(BuildContext context, Property property, VoidCallback onUpdate) async {
    final updatedProperty = await showDialog<Property>(
      context: context,
      builder: (context) => EditPropertyDialog(property: property),
    );
    if (updatedProperty != null) {
      onUpdate();
    }
  }
}

class _EditPropertyDialogState extends State<EditPropertyDialog> {
  final VoidCallback onClose;

  _EditPropertyDialogState({required this.onClose});

  late TextEditingController titleController;
  late TextEditingController detailsController;
  late TextEditingController areaController;
  late TextEditingController numRoomsController;
  late TextEditingController houseController;
  late TextEditingController streetController;
  late TextEditingController districtController;
  late TextEditingController wardController;
  late TextEditingController costController;
  late TextEditingController floorController;
  late TextEditingController rentTypecontroller;
  late TextEditingController yearBuiltController;
  late TextEditingController typeController;
  late TextEditingController conditionController;
  late TextEditingController houseOptionController;
  late TextEditingController bathController;
  late TextEditingController kitchenController;
  late TextEditingController bathTypeController;

  void getImagesFromDatabase() async {
    Database db = await DatabaseHelper().database;
    List<Uint8List?> images = await DatabaseHelper().getPhotosForProperty(widget.property.id!);

    // Заполняем imageBytesList из базы данных
    for (int i = 0; i < images.length; i++) {
      if (images[i] != null) {
        imageBytesList[i] = images[i];
      }
    }

    // Если в imageBytesList не хватает изображений до 10, заполните оставшиеся ячейки null
    if (images.length < 10) {
      for (int i = images.length; i < 10; i++) {
        imageBytesList[i] = null;
      }
    }

    setState(() {}); // Обновляем виджет после получения изображений
  }

  @override
  void initState() {
    super.initState();

    getImagesFromDatabase();

    if (!districts.contains(widget.property.district)) {
      // Если значение отсутствует в списке, добавляем его
      districts.add(widget.property.district);
    }
    selectedDistrict = widget.property.district;

    if (!conditions.contains(widget.property.condition)) {
      // Если значение отсутствует в списке, добавляем его
      conditions.add(widget.property.condition);
    }
    selectedCondition = widget.property.condition;

    if (!rentTypes.contains(widget.property.rentType)) {
      // Если значение отсутствует в списке, добавляем его
      rentTypes.add(widget.property.rentType);
    }
    selectedRentType = widget.property.rentType;

    if (!years.contains(widget.property.yearBuilt)) {
      // Если значение отсутствует в списке, добавляем его
      years.add(widget.property.yearBuilt);
    }
    selectedYear = widget.property.yearBuilt;

    if (!types.contains(widget.property.type)) {
      // Если значение отсутствует в списке, добавляем его
      types.add(widget.property.type);
    }
    selectedType = widget.property.type;

    if (!typesBath.contains(widget.property.bathroomType)) {
      // Если значение отсутствует в списке, добавляем его
      typesBath.add(widget.property.bathroomType!);
    }
    selectedValue = widget.property.bathroomType!;


    selectedRoom = widget.property.numRooms!;
    if (widget.property.bathroomOptions != null) {
      List<String> selectedValuesBathFromDB = widget.property.bathroomOptions!.split(', ');
      selectedValuesBath.addAll(selectedValuesBathFromDB);
    }

    // Проверяем, что значение из базы данных не равно null
    if (widget.property.householdOptions != null) {
      List<String> selectedValuesHouseFromDB = widget.property.householdOptions!.split(', ');
      selectedValuesHouse.addAll(selectedValuesHouseFromDB);
    }

    if (widget.property.kitchenOptions != null) {
      List<String> selectedValuesKitchenFromDB = widget.property.kitchenOptions!.split(', ');
      selectedValuesKitchen.addAll(selectedValuesKitchenFromDB);
    }



    // Инициализация контроллеров и установка значений из объекта Property
    titleController = TextEditingController(text: widget.property.title);
    detailsController = TextEditingController(text: widget.property.details);
    areaController = TextEditingController(text: widget.property.area.toString());
    numRoomsController = TextEditingController(text: widget.property.numRooms.toString());
    houseController = TextEditingController(text: widget.property.house.toString());
    streetController = TextEditingController(text: widget.property.street);
    districtController= TextEditingController(text: widget.property.district);
    wardController=TextEditingController(text: widget.property.ward.toString());
    costController=TextEditingController(text: widget.property.cost.toString());
    floorController = TextEditingController(text: widget.property.floor.toString());
    rentTypecontroller = TextEditingController(text: widget.property.rentType.toString());
    yearBuiltController = TextEditingController(text: widget.property.yearBuilt.toString());
    typeController = TextEditingController(text: widget.property.type.toString());
    conditionController = TextEditingController(text: widget.property.condition.toString());
    houseOptionController = TextEditingController(text: widget.property.householdOptions.toString());
    bathController = TextEditingController(text: widget.property.bathroomOptions.toString());
    kitchenController = TextEditingController(text: widget.property.kitchenOptions.toString());
    bathTypeController = TextEditingController(text: widget.property.bathroomType.toString());

    // Установка начальных значений для чекбоксов из базы данных
    isSuitableForChildren = widget.property.suitableForChildren == 1; // Если значение из базы данных равно 1, устанавливаем true
    isPetsAllowed = widget.property.petsAllowed== 1; // Если значение из базы данных равно 1, устанавливаем true

  }
  @override
  void dispose() {
    // Очистка контроллеров при уничтожении виджета
    titleController.dispose();
    detailsController.dispose();
    areaController.dispose();
    numRoomsController.dispose();
    houseController.dispose();
    streetController.dispose();
    districtController.dispose();
    wardController.dispose();
    costController.dispose();
    floorController.dispose();
    rentTypecontroller.dispose();
    yearBuiltController.dispose();
    typeController.dispose();
    conditionController.dispose();
    houseOptionController.dispose();
    bathController.dispose();
    kitchenController.dispose();
    bathTypeController.dispose();

    super.dispose();
  }


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
        imageBytesList[index] = loadedImageBytes;
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
    String rentType = rentTypecontroller.text; // You need to define where this value comes from
    int house = int.parse(houseController.text);
    String ward = wardController.text;
    double cost = double.parse(costController.text);
    int floor = int.parse(floorController.text);
    String type = typeController.text;
    int yearBuilt = int.parse(yearBuiltController.text);
    String condition = conditionController.text; // You need to define where this value comes from
    String status  = AuthManager.getCurrentUserName() == "admin" ? "ОПУБЛИКОВАНО" : "В РАССМОТРЕНИИ";; // You need to define where this value comes from
    int suitableForChildren = isSuitableForChildren ? 1 : 0;
    String bathroomType = bathTypeController.text; // You need to define where this value comes from
    int petsAllowed = isPetsAllowed ? 1 : 0;
    String kitchenOptions = kitchenController.text; // You need to define where this value comes from
    String bathroomOptions = bathController.text; // You need to define where this value comes from
    String householdOptions = houseOptionController.text; // You need to define where this value comes from

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


    int propertyId = await DatabaseHelper().updateProperty(db, property,widget.property.id!);

    // Вставка фотографий в базу данных
    for (int i = 0; i < imageBytesList.length; i++) {
      if (imageBytesList[i] != null) {
        await DatabaseHelper().insertPhoto(db, imageBytesList[i]!, widget.property.id!);
      } else {
        print('Предупреждение: Попытка вставить NULL значение в столбец Image');
        // Handle accordingly
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavi(),
      ),
    );
    onClose();
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
              // Карусель с изображениями
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageBytesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (imageBytesList[index] != null) {
                      return GestureDetector(
                        onTap: () => _showImageActionDialog(context, index),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.3),
                          child: Image.memory(imageBytesList[index]!),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => _openGallery(index),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.3),
                          child: Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.primaryColor),
                        ),
                      );
                    }
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
                    onPressed: _addToDatabase,

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
                          'Изменить',
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





