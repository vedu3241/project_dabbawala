class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // e.g., 'hire_accepted', 'hire_rejected', etc.
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic> data;
  
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.data,
  });
  
  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }
  
  // Create from a map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      message: map['message'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'],
      data: Map<String, dynamic>.from(map['data']),
    );
  }
  
  // Create a copy with updated fields
  NotificationModel copyWith({
    bool? isRead,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }
}