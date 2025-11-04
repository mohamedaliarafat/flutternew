// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:foodly/constants/constants.dart';
import 'package:foodly/controllers/tab_index_controller.dart';
import 'package:foodly/views/home/home_page.dart';
import 'package:foodly/views/notifications/notifications.dart';
import 'package:foodly/views/profile/profile_page.dart';
import 'package:foodly/views/search/search_page.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});

  List<Widget> pageList = const [
    HomePage(),
    SearchPage(),
    NotificationsScreen(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());
    return Obx(() => Scaffold(
       body: Stack(
        children: [
          pageList[(controller.tabIndex)],

          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: const Color(0xFF070B35)), 
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedIconTheme: const IconThemeData(color: Colors.black38),
                selectedIconTheme: const IconThemeData(color: kSecondary),
                onTap: (value) {
                  controller.setTabIndex = value;
                },
                currentIndex: controller.tabIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: controller.tabIndex == 0 
                        ? _buildFloatingIcon(AntDesign.appstore1) 
                        : const Icon(AntDesign.appstore_o, color: kOffWhite), 
                    label: 'Home'
                  ),
                  BottomNavigationBarItem(
                    icon: controller.tabIndex == 1
                        ? _buildFloatingIcon(Icons.search)
                        : const Icon(Icons.search, color: kOffWhite), 
                    label: 'Search'
                  ),
                  BottomNavigationBarItem(
                    icon: controller.tabIndex == 2
                        ? _buildFloatingIcon(Ionicons.notifications)
                        : const Icon(Ionicons.notifications_outline, color: kOffWhite), 
                    label: 'Notifications'
                  ),
                  BottomNavigationBarItem(
                    icon: controller.tabIndex == 3
                        ? _buildFloatingIcon(FontAwesome.user_circle)
                        : const Icon(FontAwesome.user_circle_o, color: kOffWhite), 
                    label: 'Profile'
                  ),
                ],
              )
            ),
          )
        ],
      ),
    )); 
  }

  // أيقونة عائمة مع ظل تدريجي
  Widget _buildFloatingIcon(IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A5C), // خلفية أيقونة عائمة
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(iconData, color: Colors.white),
    );
  }
}
