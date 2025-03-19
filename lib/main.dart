import 'package:dabbawala/features/ChatPage/screen/chat_list_screen.dart';
import 'package:dabbawala/features/Multilanguage/LocalString.dart';
import 'package:dabbawala/features/Role/screen/roleselection.dart';
import 'package:dabbawala/features/SplashPage/screens/splash_page.dart';
import 'package:dabbawala/features/authentication/screens/checkAuth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(FutureBuilder(
    future: Supabase.initialize(
      url: 'https://spvdxpxcdwvnmubedbfp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwdmR4cHhjZHd2bm11YmVkYmZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2OTQxNzgsImV4cCI6MjA1NTI3MDE3OH0.nGJrvYE_FZm3G7bY-jSAFkM4rs1XfSwUcplwGWSqnDg',
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 10,
      ),
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return const MyApp();
      }
      return const CircularProgressIndicator(); // ✅ Show loading indicator while initializing
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Localstring(),
      locale: Locale('en', 'US'),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashCheck(),
    );
  }
}
