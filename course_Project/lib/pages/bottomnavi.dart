import 'package:course_project/pages/notify.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:course_project/utils/color.dart';
import 'package:course_project/pages/account.dart';
import 'package:course_project/pages/home.dart';
import 'package:course_project/pages/myproperty.dart';
import 'package:course_project/pages/saved.dart';
import 'package:course_project/AuthManager.dart';
import 'package:course_project/pages/purpose.dart';
import 'package:course_project/data/DBHelper.dart';

class BottomNavi extends StatefulWidget {
  const BottomNavi({Key? key}) : super(key: key);

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static  List<Widget> _widgetOptions = <Widget>[
    DestinationCarousel(),
    Saved(),
    MyProperty(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    String currentUserName = AuthManager.getCurrentUserName() ?? '';
    bool isAdmin = currentUserName == 'admin';
    String myAdsText = isAdmin ? 'Предложенное' : 'Мои объекты';
    String myText = isAdmin ? 'Уведомления' : 'Избранное';
    Widget myAdsPage = isAdmin ? Purpose() : MyProperty();
    Widget myPage = isAdmin ? NotificationScreen() : Saved();
    _widgetOptions[2] = myAdsPage;
    _widgetOptions[1] = myPage;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.blue[300]!,
              hoverColor: Colors.blue[100]!,
              gap: 8,
              tabBorderRadius: 15,
              activeColor: AppColors.primaryColor,
              iconSize: 23,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue[100]!,
              color: Colors.black45,
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Главная',
                ),
                GButton(
                  text: myText,
                  icon: isAdmin ? FontAwesomeIcons.bell : FontAwesomeIcons.heart,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1; // Индекс для "Мои объявления" или "Предложенное"
                    });
                  },
                ),
                GButton(
                  text: myAdsText,
                  icon: isAdmin ? FontAwesomeIcons.cog : FontAwesomeIcons.message,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2; // Индекс для "Мои объявления" или "Предложенное"
                    });
                  },
                ),
                GButton(
                  icon: FontAwesomeIcons.user,
                  text: 'Профиль',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
