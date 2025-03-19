// Comment model class
class Comment {
  final String userId;
  final String comment;
  final String userName;
  final String? profilePicUrl;

  Comment({
    required this.userId,
    required this.comment,
    required this.userName,
    this.profilePicUrl,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user_id'],
      comment: json['comment'],
      userName: json['users']['name'],
      profilePicUrl: json['users']['profile_pic_url'],
    );
  }
}
