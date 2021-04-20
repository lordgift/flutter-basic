import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/pages/login/login_page.dart';

import 'pages/home/home_page.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoute().route,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage()
    );
  }
}