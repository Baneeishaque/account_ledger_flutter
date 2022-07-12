import 'package:flutter/material.dart';

import 'login.dart';
import 'login_form3.dart';

class AccountLedger extends StatelessWidget {
  const AccountLedger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Ledger',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Login()
      // home: LoginForm3(),
    );
  }
}
