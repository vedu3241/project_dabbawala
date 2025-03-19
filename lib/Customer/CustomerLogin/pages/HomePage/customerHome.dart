import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/controller/dabbawala_controller.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/customAppBar.dart';
import 'package:dabbawala/Customer/CustomerLogin/pages/HomePage/widgets/dabbawala_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class Customerhome extends StatelessWidget {
   Customerhome({super.key});


  @override
  Widget build(BuildContext context) {
    final DabbawalaController controller = Get.put(DabbawalaController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'dabbawalas'.tr,
              style: GoogleFonts.ubuntu(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.dabbawalas.isEmpty) {
                return const Center(child: Text('No Dabbawalas Found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: controller.dabbawalas.length,
                itemBuilder: (context, index) {
                  final dabbawala = controller.dabbawalas[index];
                  return DabbawalaCard(dabbawala: dabbawala);
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
