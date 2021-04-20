import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF36D1DC), Color(0xff5b86e5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0])),
          ),
          Column(
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
              Card(
                margin:
                    EdgeInsets.only(left: 22, top: 22, right: 22, bottom: 62),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          icon: Icon(Icons.email)),
                    ),
                    Divider(height: 28, indent: 22, endIndent: 22),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Name",
                          labelText: "Name",
                          icon: Icon(Icons.person)),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Text('Header'),
              Text('Login'),
              Text('forget button'),
              Text('sso')
            ],
          )
        ],
      ),
    );
  }
}
