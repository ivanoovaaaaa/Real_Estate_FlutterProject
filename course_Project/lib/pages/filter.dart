import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

typedef ApplyFiltersCallback = void Function(
    RangeValues areaValues,
    RangeValues costValues,
    RangeValues yearBuiltValues,
    List<String> selectedRentTypes,
    List<int> selectedRooms,
    String? selectedCondition,

    bool isSuitableForChildren,
    bool isPetsAllowed,
    );
typedef ConditionCallback = void Function(String? condition);
typedef TypesCallback = void Function(String? types);
typedef DistrictCallback = void Function(String? districts);
class FilterDialog extends StatefulWidget {
  final ApplyFiltersCallback onApplyFilters;
  final RangeValues areaValues;
  final RangeValues costValues;
  final RangeValues yearBuiltValues;
  final List<String> selectedRentTypes;

  final List<int> selectedRooms;
  final String? selectedCondition;
  final bool isSuitableForChildren;
  final bool isPetsAllowed;
  final ConditionCallback onUpdateCondition;


  FilterDialog({
    required this.onApplyFilters,
    required this.areaValues,
    required this.costValues,
    required this.yearBuiltValues,
    required this.selectedRooms,
    required this.selectedRentTypes,

    required this.selectedCondition,
    required this.isSuitableForChildren,
    required this.isPetsAllowed,
    required this.onUpdateCondition,

  });

  @override
  _FilterDialogState createState() => _FilterDialogState();

  static Future<void> show(BuildContext context, ApplyFiltersCallback onApplyFilters, {
    required RangeValues areaValues,
    required RangeValues costValues,
    required RangeValues yearBuiltValues,
    required List<String> selectedRentTypes,
    required List<int> selectedRooms,
    required String? selectedCondition,
    required bool isSuitableForChildren,
    required bool isPetsAllowed,
    required ConditionCallback onUpdateCondition,


  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onApplyFilters: onApplyFilters,
          areaValues: areaValues,
          costValues: costValues,
          yearBuiltValues: yearBuiltValues,
          selectedRooms: selectedRooms,
          selectedRentTypes:selectedRentTypes,
            selectedCondition: selectedCondition,
            isPetsAllowed:isPetsAllowed,
            isSuitableForChildren:isSuitableForChildren,
            onUpdateCondition:onUpdateCondition,
        );
      },
    );
  }


}


class _FilterDialogState extends State<FilterDialog> {
  late RangeValues areaValues;
  late RangeValues costValues;
  late RangeValues yearBuiltValues;
  late List<String> selectedRentTypes;
  late List<int> selectedRooms;
  late String? selectedCondition;
  late bool isSuitableForChildren;
  late bool isPetsAllowed;
  late ConditionCallback conditionCallback;





  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Инициализируем значения фильтров начальными значениями
    areaValues = widget.areaValues;
    costValues = widget.costValues;
    yearBuiltValues = widget.yearBuiltValues;
    selectedRooms = widget.selectedRooms;
    selectedRentTypes = widget.selectedRentTypes;
    selectedCondition = widget.selectedCondition;
    isPetsAllowed = widget.isPetsAllowed;
    isSuitableForChildren = widget.isSuitableForChildren;

  }
  List<String> conditions = ['Новый ремонт', 'Советский ремонт', 'Без ремонта'];
  List<String> rentTypes = [
    'Квартира', 'Комната', 'Новостройка', 'Дом', 'Коттедж', 'Агроусадьба'
  ];

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
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              _buildRangeSlider(
                label: 'Площадь',
                values: areaValues,
                min: 0,
                max: 1000,
                onChanged: (values) {
                  setState(() {
                    areaValues = values;
                  });
                },
              ),
              _buildRangeSlider(
                label: 'Стоимость',
                values: costValues,
                min: 0,
                max: 100000,
                onChanged: (values) {
                  setState(() {
                    costValues = values;
                  });
                },
              ),
              _buildRangeSlider(
                label: 'Год постройки',
                values: yearBuiltValues,
                min: 1900,
                max: 2025,
                onChanged: (values) {
                  setState(() {
                    yearBuiltValues = values;
                  });
                },
              ),
              _buildFilterChips2(
                label: 'Тип недвижимости',
                items: rentTypes,
                selectedItems: selectedRentTypes,
                onSelected: (rentType) {
                  setState(() {
                    if (selectedRentTypes.contains(rentType)) {
                      selectedRentTypes.remove(rentType);
                    } else {
                      selectedRentTypes.add(rentType);
                    }
                  });
                },
              ),
              _buildFilterChips(
                label: 'Количество комнат',
                items: List.generate(9, (index) => index + 1),
                selectedItems: selectedRooms,
                onSelected: (rooms) {
                  setState(() {
                    if (selectedRooms.contains(rooms)) {
                      selectedRooms.remove(rooms);
                    } else {
                      selectedRooms.add(rooms);
                    }
                  });
                },
                isRoomChip: true,
              ),
              DropdownButtonFormField<String>(
                value: selectedCondition,
                onChanged: (String? value) {
                  setState(() {
                    selectedCondition = value;
                    conditionController.text = value ?? '';
                  });
                  widget.onUpdateCondition(value); // Вызов колбэка
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
                      Text(
                        'Можно с детьми',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
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
                      Text(
                        'Можно с домашними животными',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(areaValues, costValues, yearBuiltValues, selectedRentTypes, selectedRooms, selectedCondition, isSuitableForChildren, isPetsAllowed);
                      Navigator.of(context).pop({
                        'areaValues': areaValues,
                        'costValues': costValues,
                        'yearBuiltValues': yearBuiltValues,
                        'selectedRooms': selectedRooms,
                        'selectedRentTypes':selectedRentTypes,
                        'selectedCondition': selectedCondition,
                        'isPetsAllowed':isPetsAllowed,
                        'isSuitableForChildren':isSuitableForChildren
                      });


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Применить',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Сбрасываем все фильтры
                        areaValues = RangeValues(0, 1000);
                        costValues = RangeValues(0, 100000);
                        yearBuiltValues = RangeValues(1900, 2025);
                        selectedRentTypes.clear();
                        selectedRooms.clear();
                        selectedCondition = null;
                        isSuitableForChildren = false;
                        isPetsAllowed = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Сбросить фильтры',
                          style: TextStyle(
                            color: Colors.white,
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



  Widget _buildRangeSlider({
    required String label,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              values.start.toStringAsFixed(2),
              style: TextStyle(fontSize: 14),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4, // Толщина линии слайдера
                ),
                child: RangeSlider(
                  values: values,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                  activeColor: Colors.blue, // Цвет активной части слайдера
                  inactiveColor: Colors.blue.withOpacity(0.3), // Цвет неактивной части слайдера
                  divisions: (max - min).toInt(), // Деления между минимальным и максимальным значением
                ),
              ),
            ),
            Text(
              values.end.toStringAsFixed(2),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildFilterChips({
    required String label,
    required List<dynamic> items,
    required List<dynamic> selectedItems,
    required Function(dynamic) onSelected,
    bool isRoomChip = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: items.map<Widget>((item) {
            return GestureDetector(
              onTap: () => onSelected(item),
              child: Container(
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedItems.contains(item) ? Colors.blue : Colors
                      .grey[300],
                ),
                child: Text(
                  item.toString(),
                  style: TextStyle(
                    color: selectedItems.contains(item) ? Colors.white : Colors
                        .black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildFilterChips2({
    required String label,
    required List<dynamic> items,
    required List<dynamic> selectedItems,
    required Function(dynamic) onSelected,
    bool isRoomChip = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map<Widget>((item) {
            return GestureDetector(
              onTap: () => onSelected(item),
              child: Container(
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0), // Овальная форма
                  color: selectedItems.contains(item) ? Colors.blue : Colors.grey[300],
                ),
                child: Text(
                  item.toString(),
                  style: TextStyle(
                    color: selectedItems.contains(item) ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}



