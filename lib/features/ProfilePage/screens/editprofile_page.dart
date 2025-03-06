import 'package:flutter/material.dart';
import 'package:get/get.dart';


class profilepage extends StatefulWidget {
  const profilepage({super.key});
  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('editprofile'.tr,style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
         
          ),
        
      
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
              
                  ),
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://cdn.dribbble.com/users/612255/screenshots/2607320/media/62e4e83388bfbd18596b59db62d4733c.png?compress=1&resize=400x300'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(children: [
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label:  Text('name:'.tr),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Employee Id:'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(

                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Mobile No:'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Address:'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label:  Text('email:'.tr),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('D.O.B:'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      SizedBox(
                      height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 25),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                            
                                  backgroundColor: Colors.black),
                              onPressed: () {},
                              child:  Text('save'.tr,style: TextStyle(color: Colors.white),),
                            ),
                          ),
                         
                         
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
