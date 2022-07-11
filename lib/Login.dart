import 'package:flutter/material.dart';

import 'LoginForm.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Ledger : Authentication')),
      body: LoginForm(),
    );
  }
}
