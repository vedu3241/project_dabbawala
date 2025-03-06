
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Settingscreen extends StatelessWidget {
   final List locale =[
    {'name':'ENGLISH','locale': Locale('en','US')},
    {'name':'मराठी','locale': Locale('mr','IN')},
    {'name':'हिंदी','locale': Locale('hi','IN')},
  ];

   Settingscreen({super.key});
  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }
  buildLanguageDialog(BuildContext context){
    showDialog(context: context,
        builder: (builder){
           return AlertDialog(
             title: Text('Choose Your Language'),
             content: SizedBox(
               width: double.maxFinite,
               child: ListView.separated(
                 shrinkWrap: true,
                   itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: GestureDetector(child: Text(locale[index]['name']),onTap: (){
                         print(locale[index]['name']);
                         updateLanguage(locale[index]['locale']);
                       },),
                     );
                   }, separatorBuilder: (context,index){
                     return Divider(
                       color: Colors.blue,
                     );
               }, itemCount: locale.length
               ),
             ),
           );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        GestureDetector(
          onTap: (){
             buildLanguageDialog(context);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 244, 241, 241),
            ),
            child: Text('language'.tr,style: TextStyle(color: Colors.black),),
          ),
        ),
        
          // ElevatedButton(onPressed: (){
           
          // }, child: Text('changelang'.tr)),
        ],
      )
    );
  }
}