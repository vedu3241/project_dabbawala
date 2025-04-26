// import 'dart:io';

// import 'package:dabbawala/features/ChatPage/screen/chat_list_screen.dart';
// import 'package:dabbawala/features/Multilanguage/LocalString.dart';
// import 'package:dabbawala/features/Role/screen/roleselection.dart';
// import 'package:dabbawala/features/SplashPage/screens/splash_page.dart';
// import 'package:dabbawala/features/authentication/screens/checkAuth/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // This function handles background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // // Initialize Supabase in your app startup
//   // await Supabase.initialize(
//   //   url: 'YOUR_SUPABASE_URL',
//   //   anonKey: 'YOUR_SUPABASE_ANON_KEY',
//   // );

//   ///Fire base init
//   await Firebase.initializeApp();
//   await GetStorage.init();

//   // Set up background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // Initialize local notifications plugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings();

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );

//   // Get FCM token
//   String? token = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $token');

//   // Save this token to Supabase (we'll implement this next)
//   saveTokenToSupabase(token);

//   // Handle token refreshes
//   FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToSupabase);

//   runApp(FutureBuilder(
//     future: Supabase.initialize(
//       url: 'https://spvdxpxcdwvnmubedbfp.supabase.co',
//       anonKey:
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwdmR4cHhjZHd2bm11YmVkYmZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2OTQxNzgsImV4cCI6MjA1NTI3MDE3OH0.nGJrvYE_FZm3G7bY-jSAFkM4rs1XfSwUcplwGWSqnDg',
//       realtimeClientOptions: const RealtimeClientOptions(
//         eventsPerSecond: 10,
//       ),
//     ),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.done) {
//         return const MyApp();
//       }
//       return const CircularProgressIndicator(); // ✅ Show loading indicator while initializing
//     },
//   ));
// }

// // Save token to Supabase
// Future<void> saveTokenToSupabase(String? token) async {
//   if (token == null) return;

//   try {
//     final supabase = Supabase.instance.client;

//     // Get the current user ID - this will differ based on your auth implementation
//     final user = supabase.auth.currentUser;
//     print(user);
//     if (user == null) return;

//     // Determine if this is a customer or dabbawala app
//     // This example assumes you have a way to determine user_type
//     // You might have different apps or a role field in your user table
//     String userType = 'dabbawala'; // or 'customer' for the customer app

//     // Store or update the token
//     await supabase.from('device_tokens').upsert({
//       'user_id': user.id,
//       'user_type': userType,
//       'token': token,
//       'device_info':
//           '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
//       'updated_at': DateTime.now().toIso8601String(),
//     }, onConflict: 'user_id, token');

//     print('FCM token saved to Supabase');
//   } catch (e) {
//     print('Error saving FCM token: $e');
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       translations: Localstring(),
//       locale: Locale('en', 'US'),
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: SplashCheck(),
//     );
//   }
// }

// ------------------------------------------------------------ved
import 'dart:io';

import 'package:dabbawala/features/Multilanguage/LocalString.dart';
import 'package:dabbawala/features/authentication/screens/checkAuth/splash_screen.dart';
import 'package:dabbawala/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // This function handles background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  //trying options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://spvdxpxcdwvnmubedbfp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwdmR4cHhjZHd2bm11YmVkYmZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2OTQxNzgsImV4cCI6MjA1NTI3MDE3OH0.nGJrvYE_FZm3G7bY-jSAFkM4rs1XfSwUcplwGWSqnDg',
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 10,
    ),
  );

  // Initialize GetStorage
  await GetStorage.init();

  // Set up background message handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize local notifications plugin
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // final DarwinInitializationSettings initializationSettingsIOS =
  //     DarwinInitializationSettings();

  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  // );

  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  // );

  // // Get FCM token
  // String? token = await FirebaseMessaging.instance.getToken();
  // print('FCM Token: $token');

  // // Save this token to Supabase (we'll implement this next)
  // saveTokenToSupabase(token);

  // // Handle token refreshes
  // FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToSupabase);

  // Now that everything is initialized, run the app
  runApp(const MyApp());
}


// Save token to Supabase
// Future<void> saveTokenToSupabase(String? token) async {
//   print("saveTokenFunc: $token");
//   if (token == null) return;

//   try {
//     final supabase = Supabase.instance.client;

//     // Get the current user ID - this will differ based on your auth implementation
//     final user = supabase.auth.currentUser;
//     print("supabase user id : ${user?.id}");
//     if (user == null) return;

//     // Determine if this is a customer or dabbawala app
//     String userType = 'dabbawala'; // or 'customer' for the customer app

//     // Store or update the token
//     await supabase.from('device_tokens').upsert({
//       'user_id': user.id,
//       'user_type': userType,
//       'token': token,
//       'device_info':
//           '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
//       'updated_at': DateTime.now().toIso8601String(),
//     }, onConflict: 'user_id, token');

//     print('FCM token saved to Supabase');
//   } catch (e) {
//     print('Error saving FCM token: $e');
//   }
// }

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
      home: SplashCheck(), // You can customize this based on your logic
    );
  }
}
