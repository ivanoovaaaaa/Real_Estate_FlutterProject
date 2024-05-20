class User {
  int? userId;
  String firstName;
  String lastName;
  String email;
  String password;
  String passport;
  String phone;

  User({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passport,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // userId может быть null
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'passport': passport,
      'phone': phone,
    };
  }
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['UserID'],
      firstName: map['FirstName'],
      lastName: map['LastName'],
      email: map['Email'],
      password: map['Password'],
      passport: map['Passport'],
      phone: map['Phone'],
    );
  }
}
