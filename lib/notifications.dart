// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:developer' as developer;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseMessaging.instance.setAutoInitEnabled(true);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FCM Example',
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     getFCMToken();
//   }

//   Future<void> getFCMToken() async {
//     try {
//       fcmToken = await FirebaseMessaging.instance.getToken();
//       developer.log("FCMToken: $fcmToken"); // Log token to console
//     } catch (e) {
//       developer.log("Error getting FCM token: $e"); // Log error to console
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FCM Example'),
//       ),
//       body: Center(
//         child: Text(
//           'FCM Token: $fcmToken',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
