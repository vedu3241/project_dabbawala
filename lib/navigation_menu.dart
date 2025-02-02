import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          indicatorColor: Colors.black.withOpacity(.1),
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Feed'),
            NavigationDestination(
                icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'Chat'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  /// Screens
  final screens = [
    Container(
      color: Colors.red,
      child: Center(
        child: Text("Feed"),
      ),
    ),
    Container(
      color: Colors.purple,
      child: Center(
        child: Text("Analytics"),
      ),
    ),
    Container(
      color: Colors.orange,
      child: Center(
        child: Text("Chat"),
      ),
    ),
    Container(
      color: Colors.blue,
      child: Center(
        child: Text("Profile"),
      ),
    )
  ];
}
