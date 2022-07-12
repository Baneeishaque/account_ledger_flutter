import 'package:flutter/material.dart';
import 'login_form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Ledger : Authentication')),
      body: const LoginForm(),
    );
  }
}
