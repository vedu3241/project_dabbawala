import 'package:dabbawala/features/NotificationPage/controller/notification_controller.dart';
import 'package:dabbawala/features/NotificationPage/screens/notificato_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  'dabbawalas'.tr,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        )

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(() => PostScreen());
        //   },
        //   child: const Icon(Icons.add),
        // ),
        );
  }
}
