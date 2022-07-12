import 'package:flutter/material.dart';

import 'application_specification.dart';
import 'views/home_page.dart';

class AccountLedgerMaterialApp extends StatelessWidget {
  const AccountLedgerMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ApplicationSpecification.applicationName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // useMaterial3: true
      ),
      home: const HomePage(),
    );
  }
}
