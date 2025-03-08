// lib/models/message.dart
class Message {
  final String id;
  final String groupId;
  final String userId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      groupId: json['group_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}