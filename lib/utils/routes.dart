import 'package:flutter/material.dart';
import 'package:moviflix/auth/login_page.dart';
import 'package:moviflix/auth/register_page.dart';
import 'package:moviflix/flixtix_page/flixtix_page.dart';
import 'package:moviflix/home_page/home_screen.dart';
import 'package:moviflix/todo_page/todo_page.dart';

class AppRoutes {
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String todoPage = '/todo';
  static const String moviesPage = '/movies';
  static Map<String, WidgetBuilder> routes = {
    homePage: (context) => const HomeScreen(),
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    todoPage: (context) => const TodoPage(),
    moviesPage: (context) => const FlixtixPage(),
  };
}
