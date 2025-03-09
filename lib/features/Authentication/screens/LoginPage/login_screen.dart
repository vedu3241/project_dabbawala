import 'dart:convert';

import 'package:dabbawala/features/Authentication/screens/SignUpPage/signup_screen.dart';
import 'package:dabbawala/features/HomePage/screens/home_page.dart';
import 'package:dabbawala/features/authentication/controllers/login_api_service.dart';
import 'package:dabbawala/features/dab_nav_screen.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// Dobabawala Login Screen
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final LoginApiService _loginApiService = LoginApiService();
  //Login function
  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Null check for username and password
    if (username.isEmpty || password.isEmpty) {
      THelperFunctions.showSnackBar("Please fill in both fields");
      return; // Exit the method if either field is empty
    }

    bool isSuccess = await _loginApiService.login(username, password);

    if (isSuccess) {
      // Navigate to the next screen if login is successful
      Get.to(DabAnimatedNavBar());
      THelperFunctions.showSnackBar("Login successful");
    } else {
      // Show error message if login failed
      THelperFunctions.showSnackBar("Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo
                  height: 80,
                ),
                SizedBox(height: 20),
                // Welcome Text
                Text(
                  "Welcome back!",
                  style: GoogleFonts.ubuntu(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Login to your account",
                  style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 30),
                // Username Field
                buildTextField(usernameController, Icons.person, "Username"),
                SizedBox(height: 15),
                // Password Field
                buildTextField(passwordController, Icons.lock, "Password",
                    isPassword: true),
                SizedBox(height: 20),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: Text("Sign in",
                      style: GoogleFonts.ubuntu(
                          fontSize: 18, color: Colors.white)),
                ),
                SizedBox(height: 20),
                // Social Login Divider
                Text("Or sign in with",
                    style: GoogleFonts.ubuntu(color: Colors.grey)),
                SizedBox(height: 15),
                // Social Media Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialButton("assets/icons/google.png"),
                    SizedBox(width: 20),
                    socialButton("assets/icons/facebook.png"),
                    SizedBox(width: 20),
                    socialButton("assets/icons/twitter.png"),
                  ],
                ),
                SizedBox(height: 30),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: GoogleFonts.ubuntu(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Get.to(SignupScreen());
                      },
                      child: Text("Sign up here",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, IconData icon, String hintText,
      {bool isPassword = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget socialButton(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset(assetPath, height: 30),
      ),
    );
  }
}
