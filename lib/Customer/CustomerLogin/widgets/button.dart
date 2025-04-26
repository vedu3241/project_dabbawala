import 'package:dabbawala/features/Authentication/screens/LoginPage/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/Login/screens/clogin.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.to(LoginPage()), // Fixed class reference
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.redAccent),
            child: Text(
              "customer".tr,
              style: GoogleFonts.figtree(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
            ),
          ),
        ),
        SizedBox(width: 20), // Fix: Changed from `height` to `width`
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.to(LoginScreen()),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 18),
              backgroundColor: Colors.orange,
            ),
            child: Text(
              "dabbawala".tr,
              style: GoogleFonts.figtree(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }
}
