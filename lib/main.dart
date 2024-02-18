import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:moviflix/auth/login.dart';
import 'package:moviflix/dependency_injection.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/utils/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MainApp());
  DependencyInjection.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginPage,
      // auth.currentUser == null ? AppRoutes.loginPage : AppRoutes.homePage,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
    );
  }
}
