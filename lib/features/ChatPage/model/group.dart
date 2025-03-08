class Group {
  final String id;
  final String name;
  final String adminId;
  final bool messagingDisabled;
  final DateTime createdAt;
  final bool isAdmin; // from group_members

  Group({
    required this.id,
    required this.name,
    required this.adminId,
    required this.messagingDisabled,
    required this.createdAt,
    required this.isAdmin,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      adminId: map['admin_id'] ?? '',
      messagingDisabled: map['messaging_disabled'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      isAdmin: map['is_admin'] ?? false,
    );
  }
}