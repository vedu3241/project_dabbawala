import 'dart:io';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController controller = Get.put(ProfileController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadProfileData(); // Load saved profile data when screen opens

    // Pre-fill controllers with loaded data
    firstNameController.text = controller.firstName.value;
    lastNameController.text = controller.lastName.value;
    emailController.text = controller.email.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.firstName.value.isEmpty
                  ? 'Profile Info'
                  : controller.firstName.value,
            )),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () => controller.saveProfile(
              firstNameController.text,
              lastNameController.text,
              emailController.text,
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Obx(
                () => CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImage.value.isNotEmpty
                      ? FileImage(File(controller.profileImage.value))
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.upload, color: Colors.white),
                label: const Text('Upload', style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () => controller.pickImage(),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('First Name', firstNameController),
            _buildTextField('Last Name', lastNameController),
            _buildTextField('E-mail', emailController, isReadOnly: false),
            _buildTextField('Phone Number', phoneController, isReadOnly: false),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic for password change functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Change your Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
