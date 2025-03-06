import 'package:dabbawala/features/Authentication/screens/LoginPage/login_screen.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/customerHome.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Login/screens/clogin.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/pages/custnavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo
                  height: 80,
                ),
                SizedBox(height: 50),
                // Welcome Text
                Text(
                  "Welcome back!",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Login to your account",
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 50),
                // Username Field
                buildTextField(Icons.person, "Username"),
                SizedBox(height: 15),
                // email Feild
                 buildTextField(Icons.email, "Email"),
                SizedBox(height: 15),
                // Password Field
                buildTextField(Icons.lock, "Password", isPassword: true),
                SizedBox(height: 60),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    Get.to(AnimatedNavBar());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                 child: Text("Sign Up",style: GoogleFonts.figtree(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black38),),
                ),
                SizedBox(height: 30),
                // // Social Login Divider
                // Text("-------- Or sign in with --------", style: GoogleFonts.poppins(color: Colors.grey)),
                // SizedBox(height: 15),
                // SizedBox(height: 30),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: GoogleFonts.poppins(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Get.to(LoginPage());
                      },
                      child: Text("Login",
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
}
Widget buildTextField(IconData icon, String hintText, {bool isPassword = false}) {
    return Container(
      width: double.maxFinite,
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
          prefixIcon: Icon(icon, color: Colors.black38),
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
