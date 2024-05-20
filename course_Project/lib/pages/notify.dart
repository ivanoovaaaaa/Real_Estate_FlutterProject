import 'package:course_project/AuthManager.dart';
import 'package:flutter/material.dart';

import '../data/DBHelper.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    displayNotifications();
  }

  Future<void> displayNotifications() async {
    int currentUserId = int.parse(AuthManager.getCurrentUserId()!);

    if (currentUserId != 0) {
      List<Map<String, dynamic>> landlordProperties =
      await databaseHelper.getPropertiesByOwnerId(currentUserId);

      List<Map<String, dynamic>> notificationsList = [];

      for (var property in landlordProperties) {
        List<Map<String, dynamic>> favoritesForProperty =
        await databaseHelper.getFavoritesByPropertyId(property['Id']);

        for (var favorite in favoritesForProperty) {
          Map<String, dynamic>? tenant = await databaseHelper.getUserById(
              favorite['UserId']);

          if (tenant != null) {
            notificationsList.add({
              'message': 'Пользователь ${tenant['Email']} добавил ваше объявление по адресу ${property['Street']} ${property['House']} в избранное.',
              'addingDate': favorite['AddingDate'],
            });
          }
        }
      }

      setState(() {
        notifications = notificationsList;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уведомления'),
      ),
      body: notifications.isNotEmpty
          ? ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var notification = notifications[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.grey),
            ),
            child: ListTile(
              title: Text(notification['message']),
              subtitle: Text(notification['addingDate']),
            ),
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/notfound.jpg', // Путь к вашему изображению
              width: 500, // Настройте размер изображения по вашему усмотрению
              height: 500,
            ),
            SizedBox(height: 20),
            Text(
              'Нет уведомлений', // Ваше сообщение
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

}