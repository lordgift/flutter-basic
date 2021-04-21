import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/constants/app_setting.dart';
import 'package:flutter_app/src/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: FutureBuilder<SharedPreferences>(future: SharedPreferences.getInstance(), builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(color: Colors.white);
        }
        final token = snapshot.data.getString(AppSetting.tokenSetting) ?? "";
        if (token.isNotEmpty) {
          return HomePage();
        }
        return LoginPage();
      },)
    );
  }
}