import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customAppBar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/dabbawala_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Customerhome extends StatelessWidget {
  const Customerhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
        children: [
          CustomAppBar(),
          const SizedBox(height: 10), // Reduce space after CustomAppBar
          Padding(
            padding: const EdgeInsets.only(left: 20), // Adjust left padding
            child: Text(
              'Dabbawalas Around You!',
              style: GoogleFonts.figtree(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10), // Adjust space between text and list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding
              children: [
                DabbawalaCard(
                  name: "Rajesh Kumar",
                  area: "Andheri, Mumbai",
                  rating: 4.5,
                  imagePath: 'assets/images/profilepic.png',
                ),
                DabbawalaCard(
                  name: "Suresh Singh",
                  area: "Bandra, Mumbai",
                  rating: 4.8,
                  imagePath: 'assets/images/profilepic.png',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
