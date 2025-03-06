import 'package:dabbawala/features/ProfilePage/screens/editprofile_page.dart';
import 'package:dabbawala/features/SettingsPage/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
         actions: [
            IconButton(onPressed: (){
              Get.to(() => Settingscreen());
            }, icon: Icon(Icons.settings),color: Colors.black,)
          ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 150),
              child: CircleAvatar(
                radius: 60,),
                
            ),
            ElevatedButton(onPressed: (){
              Get.to(()=>profilepage());
            }, child: Text('editprofile'.tr,style: TextStyle(color: Colors.black),))
          ],
        ),
        
        ),
        
    );
  }
}
