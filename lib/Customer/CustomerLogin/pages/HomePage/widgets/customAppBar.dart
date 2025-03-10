import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customer_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        height: MediaQuery.of(context).size.height * 0.25,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Row(
                children: [
                  Text(
                    "Hi Zubair,\nwelcome".tr,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.notifications, color: Colors.white),
                ],
              ),
              SizedBox(height: 8),
              // Location
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Themadbrains, Abohar",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CustomerSearchBar(
                  onSearch: (query) {
                    print(
                        "Searching for: $query"); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
