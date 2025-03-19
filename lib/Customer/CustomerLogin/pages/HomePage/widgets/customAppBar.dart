import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/controller/dabbawala_controller.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customer_search_bar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/Profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomAppBar extends StatelessWidget {
   CustomAppBar({super.key});
   final ProfileController profileController = Get.find<ProfileController>();
  final DabbawalaController dabbawalaController = Get.find<DabbawalaController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Container(
          padding: const EdgeInsets.all(16),
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
                  Obx(
                    () => Text(
                      'Welcome, ${profileController.firstName.value.isEmpty 
                          ? 'Guest' 
                          : profileController.firstName.value}', // Updated here
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications, color: Colors.white),
                ],
              ),
              const SizedBox(height: 8),
              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
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
              const SizedBox(height: 15),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CustomerSearchBar(
  onSearch: (query) {
    if (query.isEmpty) {
      dabbawalaController.fetchDabbawalas(); 
    } else {
      dabbawalaController.filterDabbawalas(query); 
    }
  },
)

              ),
            ],
          ),
        ),
      ),
    );
  }
}
