import 'package:dabbawala/features/HomePage/controller/posts_get_controller.dart';
import 'package:dabbawala/features/HomePage/widgets/user_post.dart';
import 'package:dabbawala/features/NotificationPage/screens/notificato_page.dart';
import 'package:dabbawala/features/ReqDocument/screens/req_doc_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PostsController postsController = Get.put(PostsController());
  final ScrollController _scrollController = ScrollController();

  Future<bool> _requestCallPermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }
    return status.isGranted;
  }

  @override
  void initState() {
    super.initState();
    // Fetch posts immediately
    postsController.fetchPosts();

    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        postsController.fetchPosts();
      }
    });
  }

  // Function to handle refresh
  Future<void> _refreshPosts() async {
    // Reset the posts and fetch from the beginning
    await postsController.refreshPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    'assets/images/logo_noBG.png',
                    width: 230,
                    height: 80,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    // Request permission first
                    if (await _requestCallPermission()) {
                      final Uri phoneUri = Uri.parse('tel:+918828059825');
                      try {
                        await launchUrl(phoneUri,
                            mode: LaunchMode.externalApplication);
                      } catch (e) {
                        print('Error launching phone call: $e');
                      }
                    } else {
                      print('Call permission denied');
                    }
                  },
                  child: Image.asset(
                    'assets/images/img_sos.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.document_scanner,
                      color: Colors.black, size: 28.0),
                  onPressed: () {
                    Get.to(() => DocumentRequestScreen());
                  },
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPosts,
                child: Obx(() {
                  // Show loading indicator when first loading
                  if (postsController.isLoading.value &&
                      postsController.posts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Show empty state if no posts and not loading
                  if (postsController.posts.isEmpty &&
                      !postsController.isLoading.value) {
                    // Using ListView to support pull-to-refresh with empty content
                    return ListView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200), // Push content to visible area
                        Center(
                          child: Text('No posts available'),
                        ),
                      ],
                    );
                  }

                  // Show posts list
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: postsController.posts.length +
                        (postsController.isLoading.value &&
                                postsController.hasMore.value
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      // Show loader at the bottom when loading more
                      if (index == postsController.posts.length &&
                          postsController.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Render post
                      final post = postsController.posts[index];
                      return UserPost(post: post);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
