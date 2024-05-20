import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_project/utils/button.dart';
import 'package:course_project/pages/signIn.dart';
import 'package:course_project/models/user.dart';
import 'package:course_project/data/DBHelper.dart';


class CreateAcc extends StatefulWidget {
  const CreateAcc({Key? key}) : super(key: key);

  @override
  State<CreateAcc> createState() => _CreateAcc();
}

class _CreateAcc extends State<CreateAcc> {
  TextEditingController countryController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool loading=false;
  bool floading=true;
  Future<bool> isDataUnique() async {
    DatabaseHelper db = DatabaseHelper();

    bool emailExists = await db.isEmailExists(emailController.text);
    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Электронная почта уже зарегистрирована.'),
        ),
      );
      return false;
    }

    bool phoneExists = await db.isPhoneExists(countryController.text);
    if (phoneExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Номер телефона уже зарегистрирован.'),
        ),
      );
      return false;
    }

    bool passportExists = await db.isPassportExists(passportController.text);
    if (passportExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Паспорт уже зарегистрирован.'),
        ),
      );
      return false;
    }

    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+375";
    super.initState();
  }
// Метод для валидации адреса электронной почты
  bool validateEmail(String email) {
    // Регулярное выражение для проверки адреса электронной почты
    String pattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // Метод для валидации номера телефона
  bool validatePhone(String phone) {
    // Регулярное выражение для проверки номера телефона
    String pattern = r'^\+375\d{9}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phone);
  }

  // Метод для валидации паспорта
  bool validatePassport(String passport) {
    // Регулярное выражение для проверки паспорта
    String pattern = r'^[A-Z]{2}\d{7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(passport);
  }

  // Метод для валидации пароля
  bool validatePassword(String password) {
    // Простая проверка: пароль должен быть не короче 6 символов
    return password.length >= 6;
  }

  // Метод для валидации совпадения паролей
  bool matchPasswords(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/reg.jpg'
              ),

              const SizedBox(
                height: 25,
              ),
              const Text(
                "Регистрация",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Введите ваше имя",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Имя",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Введите вашу фамилию",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
    controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Фамилия",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Введите ваш адрес электронной почты",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "example@gmail.com",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Введите номер мобильного телефона",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child:  TextField(
                      controller: countryController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(

                        border: InputBorder.none,
                        hintText: "+375xxxxxxxxx",
                        prefixIcon: Icon(Icons.phone),

                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Введите серию и номер вашего паспорта",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: passportController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "XX0000000",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Пароль",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true, // Скрывать введенные символы
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Введите пароль",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Подтвердите пароль",
                    style: TextStyle(color: Colors.black87),
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true, // Скрывать введенные символы
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Подтвердите пароль",
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn()));
                    },
                    child: const Text(
                      "Есть аккаунт? Войти",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),


              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: "Зарегистрироваться",
                  loading: loading,
                onTap: () async {
                  // Валидация данных
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      countryController.text.isEmpty ||
                      passportController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    // Если какое-то из полей пустое, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Все поля должны быть заполнены.'),
                      ),
                    );
                    return;
                  }
                  if (!await isDataUnique()) {
                    return;
                  }
                  if (!validateEmail(emailController.text)) {
                    // Если адрес электронной почты не соответствует формату, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Неправильный формат адреса электронной почты.'),
                      ),
                    );
                    return;
                  }

                  if (!validatePhone(countryController.text)) {
                    // Если номер телефона не соответствует формату, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Неправильный формат номера телефона.'),
                      ),
                    );
                    return;
                  }

                  if (!validatePassport(passportController.text)) {
                    // Если паспорт не соответствует формату, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Неправильный формат паспорта.'),
                      ),
                    );
                    return;
                  }

                  if (!validatePassword(passwordController.text)) {
                    // Если пароль не соответствует формату, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Пароль должен содержать не менее 6 символов.'),
                      ),
                    );
                    return;
                  }

                  if (!matchPasswords(passwordController.text, confirmPasswordController.text)) {
                    // Если пароли не совпадают, показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Пароли не совпадают.'),
                      ),
                    );
                    return;
                  }

                  // Если все проверки прошли успешно, сохраняем данные
                  User user = User(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    phone: countryController.text,
                    passport: passportController.text,
                    password: passwordController.text,
                  );

                  int userId = await DatabaseHelper().insertUser(user);
                  if (userId != null) {
                    print('Данные пользователя успешно сохранены в базе данных. ID пользователя: $userId');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Данные успешно сохранены в базе данных.'),
                      ),

                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn()));
                  } else {
                    print('Ошибка при сохранении данных пользователя в базе данных');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка при сохранении данных пользователя в базе данных.'),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}