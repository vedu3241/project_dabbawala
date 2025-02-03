// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Selectlangscreen extends StatelessWidget {
//   final List locale = [
//     {'name': 'English', 'locale': const Locale('en', 'US')},
//     {'name': 'Hindi', 'locale': const Locale('hi', 'IN')},
//     {'name': 'Marathi', 'locale': const Locale('mr', 'IN')},
//   ];

//   // Instantiate the LanguageController using GetX

//   buildialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               title: const Text('Select Language'),
//               content: Container(
//                   width: double.maxFinite,
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: locale.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                             onTap: () {
//                               // Set the selected language and navigate back
//                               Get.updateLocale(
//                                   locale[index]['locale'] as Locale);
//                               Get.back();
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(locale[index]['name'].toString()),
//                             ));
//                       })));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 20),
//         child: Column(
//           children: [
           
//                  ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.black),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       'English',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                      ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.black),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       'Hindi',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                     ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.black),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       'Marathi',
//                       style: TextStyle(color: Colors.white),
//                     ))
                    
//           ],
//         ),
//       ),
//     );
//   }
// }
