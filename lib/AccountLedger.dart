import 'package:flutter/material.dart';

import 'Login.dart';

class AccountLedger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Ledger',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Login(),
    );
  }
}