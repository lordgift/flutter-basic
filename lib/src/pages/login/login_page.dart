import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/login/background_theme.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: BackGroundTheme.gradient
            ),
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
                  "assets/images/flutter.png",
                  width: 300,
                ),
                Stack(alignment: Alignment.bottomCenter, children: [
                  Card(
                    margin:
                        EdgeInsets.only(left: 22, top: 22, right: 22, bottom: 62),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 22, top: 22, right: 22, bottom: 24),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: "User",
                                labelText: "User",
                                icon: Icon(Icons.person)),
                          ),
                          Divider(height: 28, indent: 22, endIndent: 22),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Password",
                                labelText: "Password",
                                icon: Icon(Icons.lock)),
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
                        onPressed: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                  ),
                ]),
                Text('Header'),
                Text('Login'),
                Text('forget button'),
                Text('sso')
              ],
            ),
          )
        ],
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
