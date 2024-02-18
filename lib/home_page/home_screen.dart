import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:moviflix/flixtix_page/flixtix_page.dart";
import "package:moviflix/profile_page/profile_page.dart";
import "package:moviflix/todo_page/todo_page.dart";
import "package:moviflix/utils/consts.dart";
import "package:moviflix/utils/my_colors.dart";
import "package:moviflix/utils/routes.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  final pages = [
    const TodoPage(),
    const FlixtixPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.loginPage, (route) => false);
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    _bottomNavIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: Consts.bottomNavIcons,
        activeIndex: _bottomNavIndex,
        backgroundColor: Colors.black87,
        rightCornerRadius: 20,
        leftCornerRadius: 20,
        gapLocation: GapLocation.none,
        elevation: 4,
        height: 70,
        activeColor: MyColors.appTheme,
        inactiveColor: Colors.white,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
