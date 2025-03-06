import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulate API Call
    isLoading.value = false;
    Get.snackbar("Success", "Login Successful", backgroundColor: Colors.green, colorText: Colors.white);
  }
}