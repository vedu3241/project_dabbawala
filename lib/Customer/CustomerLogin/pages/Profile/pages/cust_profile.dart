import 'package:dabbawala/Customer/CustomerLogin/pages/Payment/pages/payment_history.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/pages/edit_profile.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Settings/pages/setting_screen.dart';
import 'package:dabbawala/features/Role/screen/roleselection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/profile_controller.dart';

class CustProfile extends StatelessWidget {
  CustProfile({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  void logoutCustomer() {
    final box = GetStorage();

    // Remove the stored access token and user ID
    box.remove('access_token');
    box.remove('user_id');

    // Optionally, you can navigate the user to the login screen or another page
    Get.offAll(RoleSelectionPage());

    // Return a confirmation or update UI if needed
    print('User logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "profile".tr,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            Obx(() => CircleAvatar(
                  radius: 50,
                  backgroundImage: profileController.profileImage.value.isEmpty
                      ? const NetworkImage(
                          "https://imgs.search.brave.com/Yl7sUIxyD9b3nSG-gGNsWFVx1C5ovM6tiZZQyytg9T8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9wb3J0cmFpdC1o/YW5kc29tZS1ndXkt/c21pbGluZy1hdXR1/bW4tcGFya18xNDI5/LTY2MDMuanBnP3Nl/bXQ9YWlzX2h5YnJp/ZA")
                      : NetworkImage(profileController.profileImage.value),
                )),
            const SizedBox(height: 10),
            // Name and Email
            Obx(() => Text(
                  "${profileController.firstName.value} ${profileController.lastName.value}",
                  style: GoogleFonts.ubuntu(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Obx(() => Text(
                  profileController.email.value,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                )),
            const SizedBox(height: 20),
            _buildProfileOption(Icons.card_membership, "membership".tr,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "1200 points".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            _buildProfileOption(Icons.edit, "editprofile".tr, onTap: () {
              Get.to(EditProfile());
            }),
            _buildProfileOption(Icons.payments, "payment".tr, onTap: () {
              Get.to(PaymentDetailsScreen());
            }),
            _buildProfileOption(Icons.notifications, "notification".tr),
            _buildProfileOption(Icons.settings, "settings".tr, onTap: () {
              Get.to(CustSettingscreen());
            }),
            _buildProfileOption(Icons.logout, "logout".tr, onTap: () {
              logoutCustomer();
            }, textColor: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title, {
    Widget? trailing,
    Color textColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Stack(
        children: [
          Icon(icon, color: Colors.black),
          if (title == "Edit Profile" &&
              !profileController.isProfileComplete.value)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        title,
        style: GoogleFonts.ubuntu(color: textColor, fontSize: 16),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
