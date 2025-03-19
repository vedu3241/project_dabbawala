import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/pages/hire_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/dabbawala_model.dart';

class DabbawalaCard extends StatelessWidget {
  final Dabbawala dabbawala;

  const DabbawalaCard({
    super.key,
    required this.dabbawala,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: dabbawala.profilePicUrl != null
                ? Image.network(
                    dabbawala.profilePicUrl!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/default_profile.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dabbawala.name,
                  style:  GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dabbawala.city,
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBarIndicator(
                      rating:
                          4.5, // Placeholder value, update with actual rating logic
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (Get.context != null) {
                          Get.to(CustomerFormScreen(), arguments: {
                            'name': dabbawala.name,
                            'area': dabbawala.city,
                            'rating': 4.5,
                            'imagePath': dabbawala.profilePicUrl ??
                                'assets/images/default_profile.png',
                          });
                        } else {
                          print("Error: Get.context is null");
                        }
                      },
                      child: const Text('Hire'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
