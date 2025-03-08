import 'package:dabbawala/features/HomePage/widgets/user_post.dart';
import 'package:dabbawala/features/NotificationPage/controller/notification_controller.dart';
import 'package:dabbawala/features/NotificationPage/screens/notificato_page.dart';
import 'package:dabbawala/features/PostPage/screens/post_screen.dart';

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
              icon: const Icon(Icons.notifications,
                  color: Colors.white, size: 28.0),
              onPressed: () {
                Get.to(() => NotificationPage());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo
              height: 80,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserPost(name: users[index]);
                },
              ),
            ),
          ],
        ));
  }
}
