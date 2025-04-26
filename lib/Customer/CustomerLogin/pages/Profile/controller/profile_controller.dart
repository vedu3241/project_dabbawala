import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var profileImage = ''.obs; // Image path as String for persistence
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var isProfileComplete = false.obs;

  /// Pick Image and Save to Local Storage
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_image.png';
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
      profileImage.value = savedImage.path;
    }
  }

  /// Save Profile Details
  void saveProfile(String firstName, String lastName, String email) {
    this.firstName.value = firstName;
    this.lastName.value = lastName;
    this.email.value = email;

    isProfileComplete.value =
        firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && profileImage.value.isNotEmpty;

    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Load Saved Profile Data (Optional Improvement)
  // Future<void> loadProfileData() async {
  //   // This logic would ideally pull saved data from local storage or an API
  //   firstName.value = "Zubair";
  //   lastName.value = "Patel";
  //   email.value = "zubairpatel0326@gmail.com";
  //   profileImage.value = ""; // Load saved profile image if available
  // }
}
