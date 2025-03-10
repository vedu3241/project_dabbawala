import 'package:dabbawala/Customer/CustomerLogin/pages/Settings/pages/setting_screen.dart';
import 'package:dabbawala/features/Role/screen/roleselection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustProfile extends StatelessWidget {
  const CustProfile({super.key});

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
        title:  Text(
          "profile".tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://imgs.search.brave.com/Yl7sUIxyD9b3nSG-gGNsWFVx1C5ovM6tiZZQyytg9T8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9wb3J0cmFpdC1o/YW5kc29tZS1ndXkt/c21pbGluZy1hdXR1/bW4tcGFya18xNDI5/LTY2MDMuanBnP3Nl/bXQ9YWlzX2h5YnJp/ZA"), // Replace with actual image
            ),
            const SizedBox(height: 10),
            // Name and Email
             Text(
              "Zubair Patel",
              style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "zubairpatel0326@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("12", "customer".tr),
                  _buildStatItem("1200", "points".tr),
                  _buildStatItem("24", "ratings".tr),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            _buildProfileOption(Icons.card_membership, "membership".tr,
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Text(
                    "1200 points".tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            _buildProfileOption(Icons.payment, "Gogopay"),
            _buildProfileOption(Icons.notifications, "notification".tr),
            _buildProfileOption(Icons.settings, "settings".tr,onTap: () {
              Get.to(CustSettingscreen());
            }),
            _buildProfileOption(Icons.logout, "logout".tr,onTap: () {
              Get.to(RoleSelectionPage());
            }, textColor: Colors.red,),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style:  GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style:  GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

 Widget _buildProfileOption(
  IconData icon,
  String title, {
  Widget? trailing,
  Color textColor = Colors.black,
  VoidCallback? onTap, // Added onTap parameter
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(
      title,
      style: GoogleFonts.ubuntu(color: textColor, fontSize: 16),
    ),
    trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap, // Assigning onTap function
  );
}

}
