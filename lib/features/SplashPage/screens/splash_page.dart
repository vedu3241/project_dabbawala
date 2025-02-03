import 'package:dabbawala/features/SplashPage/services/splash_service.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   // Check if the user is logged in or not
  //   SplashServices().isLogin(context);
  // }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          
          Image.asset(
            'assets/images/splashimg1.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          // Gradient Overlay
          Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 255, 255),
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.18),
                  Colors.white.withOpacity(0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          
          
        ],
      ),
    );
  }
}
