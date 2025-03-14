



import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../LoginPage/login_screen.dart';


class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); 

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
                  "Welcome!",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Sign In to your account",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 30),
                // Username Field
                buildTextField(Icons.person, "Username"),
                SizedBox(height: 15),
                //Email feild
                 buildTextField(Icons.person, "Email"),
                SizedBox(height: 15),
                // Password Field
                buildTextField(Icons.lock, "Password", isPassword: true),
                SizedBox(height: 20),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                  child: Text("Sign in", style: GoogleFonts.poppins(fontSize: 18)),
                ),
                SizedBox(height: 20),
                // Social Login Divider
                Text("Or sign in with", style: GoogleFonts.poppins(color: Colors.grey)),
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
                    Text("Already have an account? ",
                        style: GoogleFonts.poppins(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Get.to(LoginScreen());
                      },
                      child: Text("Login here",
                          style: GoogleFonts.poppins(
                              color: Colors.black38, fontWeight: FontWeight.bold)),
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

  Widget buildTextField(IconData icon, String hintText, {bool isPassword = false}) {
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
