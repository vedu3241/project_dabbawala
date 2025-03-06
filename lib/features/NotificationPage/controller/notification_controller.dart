import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <String>[].obs;

  void addNotification(String message) {
    notifications.add(message);
  }
}