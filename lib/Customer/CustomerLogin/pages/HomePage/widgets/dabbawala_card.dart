import 'package:dabbawala/Customer/CustomerLogin/pages/Hire/pages/hire_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class DabbawalaCard extends StatelessWidget {
  final String name;
  final String area;
  final double rating;
  final String imagePath;

  const DabbawalaCard({
    super.key,
    required this.name,
    required this.area,
    required this.rating,
    required this.imagePath,
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
            child: Image.asset(
              imagePath,
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
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  area,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    // Add Hire Button
                    ElevatedButton(
                      onPressed: () {
                        // Pass dabbawala info to hire page
                        Get.to(CustomerFormScreen(), arguments: {
                          'name': name,
                          'area': area,
                          'rating': rating,
                          'imagePath': imagePath,
                        });
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