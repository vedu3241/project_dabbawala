import 'package:dabbawala/features/HomePage/widgets/user_post.dart';
import 'package:dabbawala/features/NotificationPage/screens/notificato_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> users = [
    'Vedant',
    'Zubair',
    'Mit',
    'Saim',
  ];

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'dabbawalas'.tr,
              style: GoogleFonts.acme(color: Colors.black, fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserPost(
                    name: users[index],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
