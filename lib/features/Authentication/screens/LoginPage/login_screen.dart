
import 'package:dabbawala/features/Authentication/screens/SignUpPage/signup_screen.dart';
import 'package:dabbawala/features/HomePage/screens/home_page.dart';
import 'package:dabbawala/features/Navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';




class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the Form

 

 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the GlobalKey to the Form
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Container(
                  child: Text("Welcome Back",style: GoogleFonts.acme(fontSize: 30),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // Button with increased width and custom background color
              SizedBox(
                width: double.infinity, // Set the width to the full available width
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   // Perform login action
                    
                    // }
                   Get.to(Navbarpage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 63, 63), // Set the background color
                    padding: EdgeInsets.symmetric(vertical: 15), // Adjust button height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                    ),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account?'),
                  TextButton(onPressed: (){
                   Get.to(()=> SignupScreen());
                  }, child: Text('Sign Up'))
                ],
              ),
              SizedBox(height: 10,),
              InkWell(
                 onTap: () async{
              // Actioan when the image is clicked
            
             
            },
            borderRadius: BorderRadius.circular(8), // Adds a rounded ripple effect
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Match with InkWell for consistency
              ),
              child: Image.asset(
                'assets/images/google.jpg',
                width: 100, // Adjust width as needed
                height: 50, // Adjust height as needed
              ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}