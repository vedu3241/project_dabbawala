import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/model/dabbawala_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DabbawalaInfoScreen extends StatelessWidget {
  final Dabbawala dabbawala;

  const DabbawalaInfoScreen({super.key, required this.dabbawala});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// **App Bar with Back Arrow**
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),

      /// **Body Content**
      body: Column(
        children: [
          /// **Top Half - Profile Photo**
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40, // 40% of screen height
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.network(
                dabbawala.profilePicUrl ??
                    'https://via.placeholder.com/150', // Fallback image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error, size: 80, color: Colors.red));
                },
              ),
            ),
          ),

          /// **Bottom Half - Dabbawala Details**
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **Name**
                  Text(
                    dabbawala.name,
                    style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  /// **Username**
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blueGrey),
                      const SizedBox(width: 5),
                      Text(
                        "@${dabbawala.name}",
                        style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// **Mobile Number**
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.blueAccent),
                      const SizedBox(width: 5),
                      // Text(
                      //   dabbawala.mobile_no,
                      //   style: GoogleFonts.ubuntu(fontSize: 16),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// **Address**
                  Row(
                    children: [
                      const Icon(Icons.home, color: Colors.green),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          dabbawala.address,
                          style: GoogleFonts.ubuntu(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// **Ratings**
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: 4.5, // Placeholder, replace with actual rating
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "(4.5 Ratings)", // Placeholder text
                        style: GoogleFonts.ubuntu(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  /// **Hire Button**
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0083B0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          /// **Navigates to Customer Form Screen**
                          // Get.to(() => CustomerFormScreen(), arguments: {
                          //   'id': dabbawala.id,
                          //   'name': dabbawala.name,
                          //   'area': dabbawala.city,
                          //   'imagePath': dabbawala.profilePicUrl,
                          // });
                        },
                        child: Text(
                          "Hire Dabbawala",
                          style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
