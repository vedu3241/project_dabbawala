import 'package:dabbawala/features/NotificationPage/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController = Get.find<NotificationController>();

   NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Obx(
        () => ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notificationController.notifications[index]),
            );
          },
        ),
      ),
    );
  }
}