import 'dart:convert';
import 'dart:ffi';
import 'package:dabbawala/features/HomePage/models/comment_model.dart';
import 'package:dabbawala/features/HomePage/models/post_model.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Comment model class

class PostsController extends GetxController {
  var posts = <Post>[].obs;
  var page = 1.obs;
  final int limit = 10;
  var isLoading = false.obs;
  var hasMore = true.obs;
  var error = ''.obs;

  // Comments state
  var comments = <Comment>[].obs;
  var commentPage = 1.obs;
  final int commentsPerPage = 5;
  var isLoadingComments = false.obs;
  var hasMoreComments = true.obs;
  var commentError = ''.obs;
  var currentPostId = ''.obs; // Track which post's comments we're viewing

  /// Fetch Posts with Pagination
  Future<void> fetchPosts() async {
    // Prevent multiple simultaneous requests
    if (isLoading.value || !hasMore.value) return;

    // Set loading state
    isLoading.value = true;

    try {
      String url =
          "${UsedConstants.baseUrl}/posts/paginationPost?page=${page.value}&limit=$limit";

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };

      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );

      if (response.statusCode == 200) {
        print("fetchposts Status Code: ${response.statusCode}");
        var decodedData = json.decode(response.body);
        List data = decodedData['posts'];

        if (data.isNotEmpty) {
          // Process the data
          List<Post> newPosts =
              data.map((json) => Post.fromJson(json)).toList();
          posts.addAll(newPosts);
          page.value++; // Move to next page
        } else {
          hasMore.value = false; // No more data
        }

        error.value = ''; // Clear any previous errors
      } else {
        // Handle error response
        error.value = 'Failed to load posts: ${response.statusCode}';
        print("posts API Error : ${response.body}");
      }
    } catch (e) {
      error.value = 'Error loading posts';
      print("Exception in fetchPosts: $e");
    } finally {
      // Always update loading state when done
      isLoading.value = false;
    }
  }

  /// Reset and reload posts (useful for pull-to-refresh)
  Future<void> refreshPosts() async {
    page.value = 1;
    hasMore.value = true;
    posts.clear();
    isLoading.value = false;
    await fetchPosts();
  }

  /// Toggle like on a post
  Future<void> toggleLike(String postId) async {
    try {
      // Find the post in our list
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return; // Post not found

      final post = posts[postIndex];
      final wasLiked = post.isLiked;

      // Optimistically update UI
      post.isLiked = !wasLiked;
      post.likesCount += wasLiked ? -1 : 1;
      posts[postIndex] = post;
      posts.refresh(); // Notify UI to update

      // Send API request
      String url = '${UsedConstants.baseUrl}/posts/$postId/like';

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode({"text": "This was Great!"}),
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response if needed
        final data = json.decode(response.body);

        // Check if the server provides the updated like count
        if (data['likesCount'] != null) {
          // Use the server's like count to ensure consistency
          post.likesCount = data['likesCount'];
          posts[postIndex] = post;
          posts.refresh();
        }
      } else {
        // If request failed, revert the optimistic update
        post.isLiked = wasLiked;
        post.likesCount = wasLiked ? post.likesCount + 1 : post.likesCount - 1;
        posts[postIndex] = post;
        posts.refresh();

        Get.snackbar(
          'Error',
          'Failed to update like status',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (err) {
      print("Like toggle error: $err");
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Fetch comments for a specific post with pagination
  Future<void> fetchComments(String postId, {bool loadMore = false}) async {
    // Check if we're fetching comments for a different post
    if (currentPostId.value != postId) {
      // Reset state for a new post
      comments.clear();
      commentPage.value = 1;
      hasMoreComments.value = true;
      currentPostId.value = postId;
    } else if (loadMore) {
      // If loading more comments for the same post, increment page
      commentPage.value++;
    } else if (!loadMore) {
      // If refreshing comments for the same post
      comments.clear();
      commentPage.value = 1;
      hasMoreComments.value = true;
    }

    // Prevent multiple simultaneous requests
    if (isLoadingComments.value || !hasMoreComments.value) return;

    // Set loading state
    isLoadingComments.value = true;

    try {
      String url =
          "${UsedConstants.baseUrl}/posts/$postId/comment?page=${commentPage.value}&limit=$commentsPerPage";

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };

      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );

      if (response.statusCode == 200) {
        print("fetchComments Status Code: ${response.statusCode}");
        var decodedData = json.decode(response.body);
        List data = decodedData['comments'];

        if (data.isNotEmpty) {
          // Process the data
          List<Comment> newComments =
              data.map((json) => Comment.fromJson(json)).toList();
          comments.addAll(newComments);

          // Check if we've reached the end of comments
          if (newComments.length < commentsPerPage) {
            hasMoreComments.value = false;
          }
        } else {
          hasMoreComments.value = false; // No more data
        }

        commentError.value = ''; // Clear any previous errors
      } else {
        // Handle error response
        commentError.value = 'Failed to load comments: ${response.statusCode}';
        print("comments API Error : ${response.body}");
      }
    } catch (e) {
      commentError.value = 'Error loading comments';
      print("Exception in fetchComments: $e");
    } finally {
      // Always update loading state when done
      isLoadingComments.value = false;
    }
  }

  /// Post a new comment on a post
  Future<bool> postComment(String postId, String commentText) async {
    try {
      String url = "${UsedConstants.baseUrl}/posts/$postId/comment";

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('access_token')}'
      };
      Map<String, dynamic> body = {"text": commentText};
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh comments to include the new one
        await fetchComments(postId, loadMore: false);

        // Update comment count on the post
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].commentsCount++;
          posts.refresh();
        }

        return true;
      } else {
        Get.snackbar(
          'Errorr',
          'Failed to post comment',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (err) {
      print("Post comment error: $err");
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // We'll let the initState in the widget handle the initial fetch
  }
}
