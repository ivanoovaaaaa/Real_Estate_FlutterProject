class Property {
  int? id;
  String title;
  String details;
  double area;
  int numRooms;
  int ownerId;
  int house;
  String street;
  String district;
  String rentType;
  String? ward;
  double cost;
  int floor;
  String type;
  int yearBuilt;
  String condition;
  String status;
  int? suitableForChildren;
  String? bathroomType;
  int? petsAllowed;
  String? kitchenOptions;
  String? bathroomOptions;
  String? householdOptions;

  Property({
    this.id,
    required this.title,
    required this.details,
    required this.area,
    required this.numRooms,
    required this.ownerId,
    required this.house,
    required this.street,
    required this.district,
    required this.rentType,
    this.ward,
    required this.cost,
    required this.floor,
    required this.type,
    required this.yearBuilt,
    required this.condition,
    required this.status,
    this.suitableForChildren,
    this.bathroomType,
    this.petsAllowed,
    this.kitchenOptions,
    this.bathroomOptions,
    this.householdOptions,
  });

  // Метод для создания объекта Property из Map
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      area: map['area'],
      numRooms: map['numRooms'],
      ownerId: map['ownerId'],
      house: map['house'],
      street: map['street'],
      district: map['district'],
      rentType: map['rentType'],
      ward: map['ward'],
      cost: map['cost'],
      floor: map['floor'],
      type: map['type'],
      yearBuilt: map['yearBuilt'],
      condition: map['condition'],
      status: map['status'],
      suitableForChildren: map['suitableForChildren'],
      bathroomType: map['bathroomType'],
      petsAllowed: map['petsAllowed'],
      kitchenOptions: map['kitchenOptions'],
      bathroomOptions: map['bathroomOptions'],
      householdOptions: map['householdOptions'],
    );
  }

  // Метод для создания Map из объекта Property
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'area': area,
      'numRooms': numRooms,
      'ownerId': ownerId,
      'house': house,
      'street': street,
      'district': district,
      'rentType': rentType,
      'ward': ward,
      'cost': cost,
      'floor': floor,
      'type': type,
      'yearBuilt': yearBuilt,
      'condition': condition,
      'status': status,
      'suitableForChildren': suitableForChildren,
      'bathroomType': bathroomType,
      'petsAllowed': petsAllowed,
      'kitchenOptions': kitchenOptions,
      'bathroomOptions': bathroomOptions,
      'householdOptions': householdOptions,
    };
  }
}
