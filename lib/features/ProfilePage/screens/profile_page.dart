
import 'package:dabbawala/features/HireRequest/pages/dabbawala_request_Screen.dart';
import 'package:dabbawala/features/ProfilePage/controller/profile_page_controller.dart';
import 'package:dabbawala/features/ProfilePage/model/user_profile_model.dart';
import 'package:dabbawala/features/ProfilePage/screens/post_details_screen.dart';
import 'package:dabbawala/features/Role/screen/roleselection.dart';
import 'package:dabbawala/features/SettingsPage/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DabbawalaProfileScreen extends StatefulWidget {
  const DabbawalaProfileScreen({super.key});

  @override
  State<DabbawalaProfileScreen> createState() => _DabbawalaProfileScreenState();
}

class _DabbawalaProfileScreenState extends State<DabbawalaProfileScreen> {
  Profile? profile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    _loadProfile();
    super.initState();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      ProfileApiService profileApiService = ProfileApiService();
      profile = await profileApiService.getProfile();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load profile: ${e.toString()}";
      });
    }
  }

  void logoutDabbawala() {
    final box = GetStorage();

    // Remove the stored access token and user ID
    box.remove('access_token');
    box.remove('user_id');

    // Optionally, you can navigate the user to the login screen or another page
    Get.offAll(
        RoleSelectionPage()); // Replace LoginScreen() with your actual login screen

    // Return a confirmation or update UI if needed
    print('User logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? _buildErrorWidget()
                : profile == null
                    ? Center(child: Text("No profile data available"))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // App Bar with back button and settings
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Get.to(() => Settingscreen());
                                    },
                                    icon: Icon(Icons.settings),
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),

                            // Profile Header Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Profile Image
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: NetworkImage(
                                            profile!.profilePicUrl),
                                      ),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Name
                                  Text(
                                    profile!.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Badge and Rating
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.star,
                                                color: Colors.orange, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              '4.8/5',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children:  [
                                            Icon(Icons.verified,
                                                color: Colors.blue, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'verified'.tr,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // 🔁 Open hire requests for this dabbawala
                                          // Get.to(() => DabbawalaRequestScreen());
                                        },
                                        icon:
                                            Icon(Icons.receipt_long, size: 16),
                                        label: Text(
                                          "my_request".tr,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          backgroundColor: Colors.green[600],
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                      onPressed: logoutDabbawala,
                                      icon: Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),

                            // Contact and Address Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'contact_info'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Mobile Number
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.grey),
                                      SizedBox(width: 10),
                                      Text(
                                        profile!.mobileNo,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Address
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.grey),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profile!.address.tr,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'mumbai_maha_pin'.tr,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delivery Stats Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'delivery_stats'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem('experience_years'.tr, 'experience'.tr),
                                      _buildStatItem('98.7%', 'on_time_deliveries'.tr),
                                      _buildStatItem('2,500+', 'deliveries'.tr),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Route Information
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'route_info'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:  Row(
                                      children: [
                                        Icon(Icons.train, color: Colors.grey),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'route_path'.tr,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:  Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            color: Colors.grey),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'pickup_time'.tr,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Posts Section
                            // Replace the existing ListView.builder in your _DabbawalaProfileScreenState build method
// with this GridView implementation

// Posts Section with Grid Layout
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    'recent_post'.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                    ),
                                    itemCount: profile!.posts.length,
                                    itemBuilder: (context, index) {
                                      final post = profile!.posts[index];
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigate to detailed post view
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetailScreen(post: post),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(post.postUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text(
            errorMessage ?? "Unknown error occurred",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProfile,
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(String imageUrl, String? caption, String timeAgo,
      int likes, int comments) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Caption
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Like and Comment Count
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.favorite_border,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    likes.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline,
                      color: Colors.black, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    comments.toString(),
                    style: const TextStyle(color: Colors.grey),
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
