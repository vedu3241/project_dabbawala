class Post {
  final String id;
  final String caption;
  final String postUrl;
  final String userName;
  final String userProfilePic;
  int likesCount;
  int commentsCount;
  bool isLiked; // New field to track if the current user has liked this post

  Post({
    required this.id,
    required this.userName,
    required this.userProfilePic,
    required this.postUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false, // Default to false
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      userName: json['users']['name'],
      userProfilePic: json['users']['profile_pic_url'] ?? '',
      postUrl: json['post_url'],
      caption: json['caption'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }
}
