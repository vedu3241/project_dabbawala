import 'package:dabbawala/Customer/CustomerLogin/pages/Navigation/pages/custnavbar.dart';
import 'package:dabbawala/features/Role/screen/roleselection.dart';
import 'package:dabbawala/features/dab_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashCheck extends StatefulWidget {
  const SplashCheck({super.key});

  @override
  _SplashCheckState createState() => _SplashCheckState();
}

class _SplashCheckState extends State<SplashCheck> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  Future<void> checkUserLogin() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time

    String? token = box.read('access_token');
    print(token);

    if (token != null && token.isNotEmpty) {
      bool isTokenExpired = JwtDecoder.isExpired(token);

      if (!isTokenExpired) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userRole = decodedToken['user_metadata']['role_name'] ?? '';
        print("User Role: $userRole");

        if (userRole == 'customer') {
          navigateToScreen(AnimatedNavBar());
          return;
        } else if (userRole == 'dabbewala') {
          navigateToScreen(DabAnimatedNavBar());
          return;
        }
      }
    }
    navigateToScreen(RoleSelectionPage()); // Go to login if token is invalid
  }

  void navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading spinner
      ),
    );
  }
}
