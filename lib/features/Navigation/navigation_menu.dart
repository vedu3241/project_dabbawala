import 'package:dabbawala/features/AnalytisPage/screens/analytic_screen.dart';
import 'package:dabbawala/features/ChatPage/screen/chat_screen.dart';
import 'package:dabbawala/features/HomePage/screens/home_page.dart';
import 'package:dabbawala/features/Navigation/controllers/navbar_controller.dart';
import 'package:dabbawala/features/PostPage/screens/post_screen.dart';
import 'package:dabbawala/features/ProfilePage/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
 // Import Post Page


class Navbarpage extends StatelessWidget {
  Navbarpage({super.key});

  final NavbarController navbarController = Get.put(NavbarController());

  final List<Widget> screens = [
     Homepage(),
     AnalyticScreen(),
     ChatScreen(),
     ProfilePage(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.bar_chart,
    Icons.chat,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: navbarController.selectedIndex.value,
            children: screens,
          ),

          // Floating Action Button (Post Button)
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => PostScreen()); // Navigate to Post Page
            },
            backgroundColor: Colors.black,
            elevation: 5,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // Bottom Navigation Bar
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: iconList,
            activeIndex: navbarController.selectedIndex.value,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            backgroundColor: Colors.red,
            activeColor: Colors.black,
            inactiveColor: Colors.white,
            onTap: (index) => navbarController.changeIndex(index),
          ),
        ));
  }
}
