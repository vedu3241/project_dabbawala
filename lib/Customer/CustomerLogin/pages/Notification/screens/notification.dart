import 'package:dabbawala/Customer/CustomerLogin/pages/Notification/controller/customer_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../HireHistory/pages/hire_hostory.dart';
import '../model/customer_notify_model.dart';


class NotificationScreen extends StatelessWidget {
  final String userId;
  
  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find<NotificationController>();
    final RxList<NotificationModel> notifications = controller.getNotificationsForUser(userId);
    
    return Scaffold(
      appBar: AppBar(
        title:  Text("notification".tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              controller.markAllAsRead(userId);
              Get.snackbar(
                "Success", 
                "All notifications marked as read",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: Obx(
        () => notifications.isEmpty
            ?  Center(child: Text("no_notification".tr))
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(context, notification, controller);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, 
    NotificationModel notification, 
    NotificationController controller
  ) {
    // Set color based on notification type
    Color bgColor;
    IconData notificationIcon;
    
    switch (notification.type) {
      case 'hire_accepted':
        bgColor = Colors.green.withOpacity(0.1);
        notificationIcon = Icons.check_circle;
        break;
      case 'hire_rejected':
        bgColor = Colors.red.withOpacity(0.1);
        notificationIcon = Icons.cancel;
        break;
      default:
        bgColor = Colors.blue.withOpacity(0.1);
        notificationIcon = Icons.notifications;
    }
    
    // If not read, make it slightly darker
    if (!notification.isRead) {
      bgColor = bgColor.withOpacity(0.3);
    }
    
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteNotification(userId, notification.id);
        Get.snackbar(
          "Success", 
          "Notification deleted",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      child: InkWell(
        onTap: () {
          // Mark as read
          controller.markAsRead(userId, notification.id);
          
          // Handle notification actions based on type
          if (notification.type == 'hire_accepted') {
            _handleHireAccepted(notification);
          } else if (notification.type == 'hire_rejected') {
            _handleHireRejected(notification);
          }
        },
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notification.type == 'hire_accepted' 
                      ? Colors.green.withOpacity(0.2) 
                      : Colors.red.withOpacity(0.2),
                ),
                child: Icon(
                  notificationIcon,
                  color: notification.type == 'hire_accepted' ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(notification.message),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    
                    // Show payment button if hire accepted
                    if (notification.type == 'hire_accepted' && !notification.isRead) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _handleHireAccepted(notification),
                        icon: const Icon(Icons.payment),
                        label: const Text("Go to Payment"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                    
                    // Show rejection reason if hire rejected
                    if (notification.type == 'hire_rejected') ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Reason: ${notification.data['reason']}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Handle hire accepted notification
  void _handleHireAccepted(NotificationModel notification) {
    final String requestId = notification.data['requestId'];
    
    // Navigate to hire history page
    Get.to(() => const HireHistoryScreen());
  }
  
  // Handle hire rejected notification
  void _handleHireRejected(NotificationModel notification) {
    final String requestId = notification.data['requestId'];
    final String reason = notification.data['reason'];
    
    // Navigate to hire history page
    Get.to(() => const HireHistoryScreen());
  }
  
  // Format timestamp to readable format
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}