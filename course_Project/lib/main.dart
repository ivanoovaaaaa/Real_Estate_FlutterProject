import 'package:flutter/material.dart';
import 'package:course_project/theme.dart';
import 'package:course_project/pages/startedscreen.dart';
import 'package:course_project/data/DBHelper.dart';
import 'package:course_project/models/property.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await DatabaseHelper().initDatabase();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Home App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
       home: const StartedScreen(),
      //home: PropertyListScreen(),
      // home: const BottomNavi(),
    );
  }
}
class PropertyListScreen extends StatefulWidget {
  @override
  _PropertyListScreenState createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  late Future<List<Property>> _propertyListFuture;

  @override
  void initState() {
    super.initState();
    _propertyListFuture = DatabaseHelper().getAllProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property List'),
      ),
      body: FutureBuilder(
        future: _propertyListFuture,
        builder: (context, AsyncSnapshot<List<Property>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Property> properties = snapshot.data!;
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                Property property = properties[index];
                return ListTile(
                  title: Text(property.title),
                  subtitle: Text(property.details),
                  onTap: () {
                    // Действия при нажатии на объявление
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}