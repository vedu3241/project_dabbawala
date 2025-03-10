import 'package:dabbawala/Customer/CustomerLogin/pages/Login/controller/auth_controller.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/pages/custnavbar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/SignUp/screen/csignup.dart';
import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


   Future<void> clogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Null check for username and password
    if (email.isEmpty || password.isEmpty) {
      THelperFunctions.showSnackBar("Please fill in both fields");
      return; // Exit the method if either field is empty
    }

    // bool isSuccess = await _loginApiService.login(username, password);
bool isSuccess = await CLoginApiService().clogin(email, password);
    if (isSuccess) {
      // Navigate to the next screen if login is successful
      Get.to(AnimatedNavBar());
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
                  height: 70,
                ),
                SizedBox(height: 30),
                // Welcome Text
                Text(
                  "Welcome back!",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Sign In to your account",
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 50),
                // Username Field
                buildTextField(Icons.mail, "Email",emailController),
                SizedBox(height: 15),
                // Password Field
                buildTextField(Icons.lock, "Password", isPassword: true,passwordController),
                SizedBox(height: 60),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                 clogin();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                 child: Text("Sign In",style: GoogleFonts.figtree(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black38),),
                ),
                SizedBox(height: 30),
                // Social Login Divider
                Text("-------- Or sign in with --------", style: GoogleFonts.poppins(color: Colors.grey)),
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
                        style: GoogleFonts.poppins(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Get.to(SignupPage());
                      },
                      child: Text("Sign up here",
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

  Widget buildTextField(IconData icon, String hintText, TextEditingController emailController, {bool isPassword = false}) {
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
