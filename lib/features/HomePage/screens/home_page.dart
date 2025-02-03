import 'package:dabbawala/features/NotificationPage/screens/notificato_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';



class Homepage extends StatelessWidget {
  const Homepage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(
                  color: Colors.white, Icons.notifications, size: 28.0),
              onPressed: () {
                Get.to(NotificatonPage());
              },
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.qr_code_sharp,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Text(
                  
                        'dabbawalas'.tr,
                    style: GoogleFonts.acme(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        );
        
  }
}
