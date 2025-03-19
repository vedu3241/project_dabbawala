import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HireHistory/pages/hire_hostory.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/pages/hire_page.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/customerHome.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/controller/custNavbar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/controller/userController.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/pages/cust_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedNavBar extends StatelessWidget {
  final NavController navController = Get.put(NavController());
  final UserController userController = Get.put(UserController()); // Added UserController

  final List<Widget> pages = [
    Customerhome(),
    CustomerFormScreen(),
    HireHistoryScreen(),
    CustProfile(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.work,
    Icons.workspace_premium,
    Icons.person_4,
  ];

  AnimatedNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Stack(
        children: [
          Obx(
            () => AnimatedBottomNavigationBar(
              icons: iconList,
              activeIndex: navController.currentIndex.value,
              gapLocation: GapLocation.none,
              backgroundColor: Colors.white,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 20,
              rightCornerRadius: 0,
              onTap: (index) => navController.changeTab(index),
            ),
          ),
          // Profile Badge Overlay
          Obx(() {
            if (!userController.isProfileComplete.value) {
              return Positioned(
                bottom: 10,
                right: MediaQuery.of(context).size.width * 0.09, // Adjust position
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink(); // If profile is complete, hide badge
          }),
        ],
      ),
    );
  }
}
