import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Customer_Search_Bar extends StatelessWidget {
  const Customer_Search_Bar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.black38),
        hintText: "Find Your Dabbawala",
        hintStyle: GoogleFonts.poppins(color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}