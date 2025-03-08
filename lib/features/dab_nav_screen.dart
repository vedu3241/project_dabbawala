import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dabbawala/features/AnalytisPage/screens/analytic_screen.dart';
import 'package:dabbawala/features/ChatPage/screen/chat_screen.dart';
import 'package:dabbawala/features/HomePage/screens/home_page.dart';
import 'package:dabbawala/features/ProfilePage/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DabAnimatedNavBar extends StatelessWidget {
  DabAnimatedNavBar({super.key});

  final NavController navController = Get.put(NavController());

  final List<Widget> pages = [
    Homepage(),
    AnalyticScreen(),
    ChatScreen(),
    ProfilePage()
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.analytics,
    Icons.chat,
    Icons.person
  ];

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

class NavController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
