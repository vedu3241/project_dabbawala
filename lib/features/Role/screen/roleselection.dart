import 'package:dabbawala/Customer/CustomerLogin/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 180, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/images/logo.png',width: 300,),
              SizedBox(height: 445),
              Text(
                "Login as?",
                style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold),

              ),
              SizedBox(height: 40),
              Button(),
            ],
          ),
        ),
      ),
    );
  }
}

