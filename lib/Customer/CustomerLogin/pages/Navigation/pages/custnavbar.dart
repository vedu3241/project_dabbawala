import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Calendar/pages/cust_calendar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/pages/hire_page.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/customerHome.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/controller/custNavbar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/pages/cust_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedNavBar extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  final List<Widget> pages = [
    Customerhome(),
    CustomerFormScreen(),
    CalendarScreen(),
    CustProfile(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.work,
    Icons.calendar_today,
    Icons.person_4
  ];

   AnimatedNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: navController.currentIndex.value,
          gapLocation: GapLocation.none,
          backgroundColor: Colors.white,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 20, // You can keep leftCornerRadius
          rightCornerRadius: 0, // Set to 0 to avoid NonAppropriatePathException
          onTap: (index) => navController.changeTab(index),
        ),
      ),
    );
  }
}
