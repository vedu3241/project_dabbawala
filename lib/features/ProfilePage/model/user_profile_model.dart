// Define the Profile model class
class Profile {
  final String id;
  final String name;
  final String mobileNo;
  final String username;
  final String address;
  final String profilePicUrl;
  final List<Post> posts;

  Profile({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.username,
    required this.address,
    required this.profilePicUrl,
    required this.posts,
  });

  // Factory constructor to create a Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    var postsJson = json['posts'] as List;
    List<Post> postsList = postsJson.map((postJson) => Post.fromJson(postJson)).toList();

    return Profile(
      id: json['id'],
      name: json['name'],
      mobileNo: json['mobile_no'],
      username: json['username'],
      address: json['address'],
      profilePicUrl: json['profile_pic_url'],
      posts: postsList,
    );
  }

  // Convert Profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile_no': mobileNo,
      'username': username,
      'address': address,
      'profile_pic_url': profilePicUrl,
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}

// Define the Post model class
class Post {
  final String id;
  final int likes;
  final String? caption; // Using nullable String since caption can be null
  final int comments;
  final String postUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.likes,
    this.caption,
    required this.comments,
    required this.postUrl,
    required this.createdAt,
  });

  // Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      likes: json['likes'],
      caption: json['caption'],
      comments: json['comments'],
      postUrl: json['post_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'likes': likes,
      'caption': caption,
      'comments': comments,
      'post_url': postUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Example usage to parse the complete response
class ProfileResponse {
  final Profile profile;

  ProfileResponse({required this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
    };
  }
}