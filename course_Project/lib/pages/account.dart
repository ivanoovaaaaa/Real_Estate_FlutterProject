import 'package:course_project/pages/advDialog.dart';
import 'package:course_project/pages/startedscreen.dart';
import 'package:flutter/material.dart';
import 'package:course_project/utils/color.dart';
import 'package:course_project/AuthManager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:course_project/pages/notify.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body:  Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration:const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.arrow_back_ios, size: 20,  color: AppColors.primaryColor,)),
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    const Text('Мой Профиль', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),)
                  ],
                ),
              ),

            ),
          ),
          Positioned(
            top: 130,
            right: 30,
            left: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text('${AuthManager.getCurrentUserName() ?? "Unknown"}', style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        )),

                         SizedBox(height: 10),
                        // Отображение ID текущего пользователя
                        Text('ID: ${AuthManager.getCurrentUserId() ?? "Unknown"}', style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: 15,
            right: 15,
            bottom: 0,
            child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ACCOUNT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const[
                          Icon(Icons.account_circle_rounded, size: 35,  color: AppColors.primaryColor,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Аккаунт', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),


                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          AddPropertyDialog.show(context);
                        },


                        child: Row(
                          children: const [
                            Icon(Icons.add_box,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Добавить объявление", style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                            Icon(Icons.arrow_forward_ios,  color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotificationScreen(),
                            ),
                          );
                        },


                        child: Row(
                          children: const [
                            Icon(FontAwesomeIcons.bell,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Уведомления", style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                            Icon(Icons.arrow_forward_ios,  color: AppColors.primaryColor,)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:const [
                          Icon(Icons.help, size: 35,  color: AppColors.primaryColor,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Контакты и помощь', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.help_center_rounded,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Помощь",style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                            Icon(Icons.arrow_forward_ios,  color: AppColors.primaryColor,),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.email,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("О нас",style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                            Icon(Icons.arrow_forward_ios,  color: AppColors.primaryColor,),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.report_gmailerrorred,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Правила",style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                            Icon(Icons.arrow_forward_ios,  color: AppColors.primaryColor,),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      //Others
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const[
                          Icon(Icons.restore_page, size: 35,  color: AppColors.primaryColor,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Другое', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> StartedScreen()));
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.logout,  color: AppColors.primaryColor,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Выход",style: TextStyle(
                              color: AppColors.primaryColor,
                            ),)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[

                        ],
                      )
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}