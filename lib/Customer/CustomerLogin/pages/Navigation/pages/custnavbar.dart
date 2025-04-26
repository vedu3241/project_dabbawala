import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/customerHome.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/controller/custNavbar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Notification/screens/notification.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/controller/userController.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/pages/cust_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../HomePage/widgets/Pending_request.dart';

class AnimatedNavBar extends StatelessWidget {
  final Custnavbar navController = Get.put(Custnavbar());
  final UserController userController = Get.put(UserController());

  final List<Widget> pages = [
    Customerhome(),
    NotificationScreen(userId: 'b436e769-6946-4ed2-b1c6-36a8d1fd3a64'),
    PendingRequestsScreen(),
    CustProfile(),
  ];

  final List<String> iconAssetList = [
    'assets/images/home.png',
    'assets/images/bell.png',
    'assets/images/pending.png',
    'assets/images/profile_nav.png',
  ];

  AnimatedNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(() {
        return AnimatedBottomNavigationBar.builder(
          itemCount: iconAssetList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.blue : Colors.grey;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconAssetList[index],
                  width: 24,
                  height: 24,
                  color: color,
                ),
              ],
            );
          },
          activeIndex: navController.currentIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 20,
          rightCornerRadius: 0,
          onTap: (index) => navController.changeTab(index),
          backgroundColor: Colors.white,
        );
      }),
      floatingActionButton: Obx(() {
        if (!userController.isProfileComplete.value) {
          return Positioned(
            bottom: 65,
            right: MediaQuery.of(context).size.width * 0.15,
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
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
