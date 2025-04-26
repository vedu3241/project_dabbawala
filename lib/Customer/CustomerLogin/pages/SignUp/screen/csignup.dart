import 'dart:io';
import 'package:dabbawala/Customer/CustomerLogin/pages/Login/screens/clogin.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/SignUp/controller/register_controller.dart';
import 'package:dabbawala/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // **Text Editing Controllers**
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // **Pick Image Function**
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> registerUser() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String address = addressController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || name.isEmpty || address.isEmpty) {
      THelperFunctions.showSnackBar("Please fill in all fields");
      return; // Exit the method if any field is empty
  }

    bool isSuccess = await RegisterApiService().registerUser(name, username, address, "", email, password);

    if (isSuccess) {
      Get.to(() => const LoginPage());
      THelperFunctions.showSnackBar("Registration successful");
    } else {
      THelperFunctions.showSnackBar("Registration failed");}
    }
  @override
  void dispose() {
    // **Dispose controllers to free memory**
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/logo.png', // Replace with your logo
                    height: 70,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "Create your account",
                  style: GoogleFonts.ubuntu(
                      fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                SizedBox(height: 15),
                // Name Field
                buildTextField(Icons.person, "Name", nameController),
                SizedBox(height: 15),
                // Username Field
                buildTextField(Icons.person, "Username", usernameController),
                SizedBox(height: 15),
                // Email
                buildTextField(Icons.mail, "Email", emailController),
                SizedBox(height: 15),
                // Password Field
                buildTextField(Icons.lock, "Password", passwordController, isPassword: true),
                SizedBox(height: 15),
                // Address Field
                buildTextField(Icons.location_on_rounded, "Address", addressController),
                SizedBox(height: 35),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                   registerUser();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.figtree(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black38),
                  ),
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
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: GoogleFonts.poppins(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Get.to(LoginPage());
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(color: Colors.black38, fontWeight: FontWeight.bold),
                      ),
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

// **Reusable Text Field Widget**
Widget buildTextField(IconData icon, String hintText, TextEditingController controller, {bool isPassword = false}) {
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
      controller: controller,
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

// **Social Media Button**
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

 
