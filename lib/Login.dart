import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'LoginForm.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text('Account Ledger : Authentication'),
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])),
      body: LoginForm(),
    );
  }
}