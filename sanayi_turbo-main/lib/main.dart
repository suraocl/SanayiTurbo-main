import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:sanayi_turbo/firebase_options.dart';
import 'package:sanayi_turbo/interface/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanayi_turbo/interface/pages/add_product_page.dart';
import 'package:sanayi_turbo/interface/pages/home_page.dart';
import 'package:sanayi_turbo/interface/pages/user_ditail_page.dart';
import 'package:sanayi_turbo/interface/screens/login_screen.dart';
import 'package:sanayi_turbo/service/push_notification_helper.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationHelper.displayNotification;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: Grock.navigationKey, // added line
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: _auth.currentUser != null
          ? const BottomNavBar(
              page1: HomePage(),
              page2: AddProductPage(),
              page3: UserDitailPage(),
            )
          : const LoginScreen(),
    );
  }
}
