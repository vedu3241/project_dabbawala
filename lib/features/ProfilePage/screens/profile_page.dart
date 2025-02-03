import 'package:dabbawala/features/SettingsPage/screens/settings_page.dart';
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
    final size = MediaQuery.of(context).size;
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(onPressed: (){
              Get.to(() => Settingscreen());
            }, icon: Icon(Icons.settings),color: Colors.white,)
          ],
          ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
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
                    height: 40,
                  ),
                  Container(
                    child: Column(children: [
                      SizedBox(
                        width: 330,
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Name:'),
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
                              label: const Text('Email:'),
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
                        height: size.height*0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(width: size.width*0.15),
                          FloatingActionButton.extended(
                            label: const Text('Save'), // <-- Text
                            backgroundColor: const Color(0xFF4e0064),
                            icon: const Icon(
                              Icons.person,
                              // size: 24.0,
                            ),
                            onPressed: () {
                      //  Navigator.push(context,MaterialPageRoute(builder: (context) => DocumentPage()));
                            },
                          ),
                          SizedBox(width: size.width*0.03),
                          FloatingActionButton.extended(
                            label: const Text('Logout'),
                            backgroundColor: const Color(0xFF4e0064),
                            icon: const Icon(
                              Icons.logout,
                              
                            ),
                            onPressed: () {
                      //  Navigator.push(context,MaterialPageRoute(builder: (context) => DocumentPage()));
                            },
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
