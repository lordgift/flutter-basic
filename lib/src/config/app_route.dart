import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/home/home_page.dart';
import 'package:flutter_app/src/pages/login/login_page.dart';

class AppRoute {
  static const homeRoute = "home";
  static const loginRoute = "login";

  get route => _route;

  final _route = <String, WidgetBuilder> {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage()
  };
}