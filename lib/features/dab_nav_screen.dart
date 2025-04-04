// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:dabbawala/features/AnalytisPage/screens/analytic_screen.dart';
// import 'package:dabbawala/features/ChatPage/screen/chat_list_screen.dart';
// import 'package:dabbawala/features/ChatPage/screen/chat_screen.dart';
// import 'package:dabbawala/features/HomePage/screens/create_post.dart';

// import 'package:dabbawala/features/HomePage/screens/home_page.dart';
// import 'package:dabbawala/features/ProfilePage/screens/profile_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DabAnimatedNavBar extends StatelessWidget {
//   DabAnimatedNavBar({super.key});

//   final NavController navController = Get.put(NavController());

//   final List<Widget> pages = [
//     Homepage(),
//     CreatePostPage(),
//     AnalyticScreen(),
//     ChatListScreen(),
//     DabbawalaProfileScreen()
//   ];

//   final List<IconData> iconList = [
//     Icons.home,
//     Icons.add_box,
//     Icons.analytics,
//     Icons.chat,
//     Icons.person
//   ];

//   //  'assets/images/home.png',
//   //   'assets/images/add.png',
//   //   'assets/images/analytics.png',
//   //   'assets/images/live-chat.png',
//   //   'assets/images/profile_nav.png',

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() => pages[navController.currentIndex.value]),
//       bottomNavigationBar: Obx(
//         () => AnimatedBottomNavigationBar(
//           icons: iconList,
//           activeIndex: navController.currentIndex.value,
//           gapLocation: GapLocation.none,
//           backgroundColor: Colors.white,
//           activeColor: Colors.blue,
//           inactiveColor: Colors.grey,
//           notchSmoothness: NotchSmoothness.softEdge,
//           leftCornerRadius: 20, // You can keep leftCornerRadius
//           rightCornerRadius: 0, // Set to 0 to avoid NonAppropriatePathException
//           onTap: (index) => navController.changeTab(index),
//         ),
//       ),
//     );
//   }
// }

// class NavController extends GetxController {
//   var currentIndex = 0.obs;

//   void changeTab(int index) {
//     currentIndex.value = index;
//   }
// }

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dabbawala/features/AnalytisPage/screens/analytic_screen.dart';
import 'package:dabbawala/features/ChatPage/screen/chat_list_screen.dart';
import 'package:dabbawala/features/HomePage/screens/create_post.dart';
import 'package:dabbawala/features/HomePage/screens/home_page.dart';
import 'package:dabbawala/features/ProfilePage/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DabAnimatedNavBar extends StatelessWidget {
  DabAnimatedNavBar({super.key});

  final NavController navController = Get.put(NavController());

  final List<Widget> pages = [
    Homepage(),
    CreatePostPage(),
    AnalyticScreen(),
    ChatListScreen(),
    DabbawalaProfileScreen(),
  ];

  final List<String> imageList = [
    'assets/images/home.png',
    'assets/images/add.png',
    'assets/images/analytics.png',
    'assets/images/live-chat.png',
    'assets/images/profile_nav.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar.builder(
          itemCount: imageList.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageList[index],
                  width: 24,
                  height: 24,
                  color: isActive ? Colors.blue : Colors.black,
                ),
              ],
            );
          },
          activeIndex: navController.currentIndex.value,
          gapLocation: GapLocation.none,
          backgroundColor: Colors.white,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 20,
          rightCornerRadius: 0,
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
