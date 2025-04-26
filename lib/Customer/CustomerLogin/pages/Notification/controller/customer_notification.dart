import 'package:get/get.dart';
import '../model/customer_notify_model.dart';


class NotificationController extends GetxController {
  // Notifications mapped by user ID
  final RxMap<String, RxList<NotificationModel>> userNotifications = <String, RxList<NotificationModel>>{}.obs;
   List<Map<String, dynamic>> notifications = []; 
  // Get notifications for a specific user
  RxList<NotificationModel> getNotificationsForUser(String userId) {
    if (!userNotifications.containsKey(userId)) {
      userNotifications[userId] = <NotificationModel>[].obs;
    }
    return userNotifications[userId]!;
  }
  
  // Add a notification
  void addNotification(
    String userId,
    String title,
    String message,
    String type,
    Map<String, dynamic> data,
  ) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      data: data,
    );
    
    getNotificationsForUser(userId).add(notification);
  }
  
  // Mark notification as read
  void markAsRead(String userId, String notificationId) {
    if (userNotifications.containsKey(userId)) {
      final notifications = userNotifications[userId]!;
      final index = notifications.indexWhere((n) => n.id == notificationId);
      
      if (index != -1) {
        final updatedNotification = notifications[index].copyWith(isRead: true);
        notifications[index] = updatedNotification;
      }
    }
  }
  
  // Mark all notifications as read
  void markAllAsRead(String userId) {
    if (userNotifications.containsKey(userId)) {
      final notifications = userNotifications[userId]!;
      final updatedNotifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
      userNotifications[userId]!.value = updatedNotifications;
    }
  }
  
  // Delete a notification
  void deleteNotification(String userId, String notificationId) {
    if (userNotifications.containsKey(userId)) {
      final notifications = userNotifications[userId]!;
      notifications.removeWhere((n) => n.id == notificationId);
    }
  }
}