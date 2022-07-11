import 'package:flutter/material.dart';

import 'Login.dart';
import 'LoginForm3.dart';

class AccountLedger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Ledger',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Login()
      // home: LoginForm3(),
    );
  }
}
