import 'package:flutter/material.dart';
import 'package:dabbawala/features/ProfilePage/model/user_profile_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Image
            Image.network(
              post.postUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            // Post Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Like and Comment Count
                  Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.red, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        post.likes.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.chat_bubble_outline, color: Colors.black, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        post.comments.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Caption
                  if (post.caption != null && post.caption!.isNotEmpty)
                    Text(
                      post.caption!,
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 8),
                  
                  // Time
                  Text(
                    "2 days ago",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}