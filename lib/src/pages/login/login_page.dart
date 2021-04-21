import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/constants/app_setting.dart';
import 'package:flutter_app/src/pages/login/background_theme.dart';
import 'package:flutter_app/src/view_models/sso_viewmodel.dart';
import 'package:flutter_app/src/constants/assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(gradient: BackGroundTheme.gradient),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                ),
                Image.asset(
                  Asset.logoImage,
                  width: 300,
                ),
                Stack(alignment: Alignment.bottomCenter, children: [
                  Card(
                    margin: EdgeInsets.only(
                        left: 22, top: 22, right: 22, bottom: 24),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 22, top: 22, right: 22, bottom: 62),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: "User",
                                labelText: "User",
                                icon: Icon(Icons.person)),
                            controller: _usernameController,
                          ),
                          Divider(height: 28, indent: 22, endIndent: 22),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Password",
                                labelText: "Password",
                                icon: Icon(Icons.lock)),
                            obscureText: true,
                            controller: _passwordController,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: _boxDecoration(),
                    width: 280,
                    height: 52,
                    child: TextButton(
                        onPressed: () async {
                          print('login clicked!!');
                          final username = _usernameController.text;
                          final password = _passwordController.text;

                          if (username == "" && password == "") {
                            print("login ok");

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var token = "abcdefghijklmnopqrstuvwxyz";
                            await prefs.setString(AppSetting.tokenSetting, token);
                            await prefs.setString(AppSetting.usernameString, username);

                            Navigator.pushReplacementNamed(context, AppRoute.homeRoute);
                          } else {
                            print("Invalid password");
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ]),
                _buildTextButton("forget password", onPressed: () {}),
                SSOButton(),
                _buildTextButton("register", onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildTextButton(String text, {VoidCallback onPressed}) {
    return Container(
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white70),
        ),
        onPressed: onPressed,
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    final gradientStart = BackGroundTheme().gradientStart;
    final gradientEnd = BackGroundTheme().gradientEnd;

    final boxShadowItem = (Color color) => BoxShadow(
          color: color,
          offset: Offset(1.0, 6.0),
          blurRadius: 20.0,
        );

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      boxShadow: <BoxShadow>[
        boxShadowItem(gradientStart),
        boxShadowItem(gradientEnd),
      ],
      gradient: LinearGradient(
        colors: [
          gradientEnd,
          gradientStart,
        ],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1.0, 1.0),
        stops: [0.0, 1.0],
      ),
    );
  }
}

class SSOButton extends StatelessWidget {
  const SSOButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: SSOViewModel()
              .item
              .map((e) => FloatingActionButton(
                    heroTag: e.backgroundColor.toString(),
                    onPressed: () {},
                    child: FaIcon(e.icon),
                    backgroundColor: e.backgroundColor,
                  ))
              .toList()),
    );
  }
}
