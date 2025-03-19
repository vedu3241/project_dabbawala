import 'package:dabbawala/features/HomePage/controller/posts_get_controller.dart';
import 'package:dabbawala/features/HomePage/models/comment_model.dart';
import 'package:dabbawala/features/HomePage/models/post_model.dart';
import 'package:dabbawala/features/HomePage/widgets/double_tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class UserPost extends StatelessWidget {
  const UserPost({super.key, required this.post});

  final Post post;

  void _showCommentSection(BuildContext context) {
    final PostsController postsController = Get.find<PostsController>();
    final ScrollController scrollController = ScrollController();
    final TextEditingController commentController = TextEditingController();

    // Initialize by loading the first page of comments
    postsController.fetchComments(post.id);

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          postsController.hasMoreComments.value) {
        postsController.fetchComments(post.id, loadMore: true);
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, _) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Comments",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  // Comments list
                  Expanded(
                    child: Obx(() {
                      if (postsController.isLoadingComments.value &&
                          postsController.comments.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else if (postsController
                          .commentError.value.isNotEmpty) {
                        return Center(
                            child: Text(postsController.commentError.value));
                      } else if (postsController.comments.isEmpty) {
                        return Center(child: Text('No comments yet'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: postsController.comments.length +
                            (postsController.hasMoreComments.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == postsController.comments.length) {
                            // Show loading indicator at the end for more comments
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final comment = postsController.comments[index];
                          return _buildComment(comment);
                        },
                      );
                    }),
                  ),
                  // Comment input field
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 8.0,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            post.userProfilePic,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child:
                                  Icon(Icons.person, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Obx(
                          () => postsController.isLoadingComments.value &&
                                  commentController.text.isNotEmpty
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: Icon(Icons.send, color: Colors.blue),
                                  onPressed: () async {
                                    if (commentController.text
                                        .trim()
                                        .isNotEmpty) {
                                      final success =
                                          await postsController.postComment(
                                              post.id,
                                              commentController.text.trim());
                                      if (success) {
                                        commentController.clear();
                                      }
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Clean up when bottom sheet is closed
      scrollController.dispose();
      // commentController.dispose();
    });
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile picture
          comment.profilePicUrl != null
              ? ClipOval(
                  child: Image.network(
                    comment.profilePicUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(),
                  ),
                )
              : _buildDefaultAvatar(),
          SizedBox(width: 10),
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(comment.comment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 20,
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostsController postsController = Get.find<PostsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // User info section
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // User Profile Picture
              ClipOval(
                child: InstaImageViewer(
                  child: Image.network(
                    post.userProfilePic,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              //user name
              Text(
                post.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // More options
              Icon(Icons.more_horiz)
            ],
          ),
        ),

        // Post image with double-tap to like
        DoubleTapLikeAnimation(
          onDoubleTap: () {
            // Find the current post
            final currentPost = postsController.posts.firstWhere(
              (p) => p.id == post.id,
              orElse: () => post,
            );

            // Only like if not already liked
            if (!currentPost.isLiked) {
              postsController.toggleLike(post.id);
            }
          },
          child: InstaImageViewer(
            // Added InstaImageViewer for better post image viewing
            child: Image.network(
              post.postUrl,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 400,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.image_not_supported,
                      size: 50, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        ),

        // Post actions (like, comment, share)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              // Like button with animation
              Obx(() {
                // Find the post in the controller's list to get updated status
                final currentPost = postsController.posts.firstWhere(
                  (p) => p.id == post.id,
                  orElse: () => post,
                );

                return GestureDetector(
                  onTap: () {
                    postsController.toggleLike(post.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Image.asset(
                        currentPost.isLiked
                            ? 'assets/images/like_filled.png' // Path to your filled like image
                            : 'assets/images/like_outline.png', // Path to your outlined like image
                        key: ValueKey<bool>(currentPost.isLiked),
                        width: 26, // Set the desired width
                        height: 26, // Set the desired height
                      ),
                    ),
                  ),
                );
              }),

              // Like count
              Obx(() {
                final currentPost = postsController.posts.firstWhere(
                  (p) => p.id == post.id,
                  orElse: () => post,
                );
                return Text(currentPost.likesCount.toString());
              }),

              const SizedBox(width: 12),

              // Comment button
              GestureDetector(
                onTap: () {
                  _showCommentSection(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(
                    'assets/images/comment.png',
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
              Text(post.commentsCount.toString()),

              const SizedBox(width: 12),

              // Share button
              Image.asset(
                'assets/images/share.png',
                width: 22,
                height: 22,
              ),
            ],
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: post.caption.isNotEmpty
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: post.userName + " ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: post.caption,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
