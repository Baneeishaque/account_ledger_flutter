import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import '../utils/app_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(onPressed: () {}, child: const Text('Login')),
            const TextButton(onPressed: null, child: Text('Register')),
            ElevatedButton(onPressed: () {}, child: const Text('List Users')),
            const TextButton(
                onPressed: null, child: Text('Balance Sheet for an User')),
            const TextButton(
                onPressed: null, child: Text('Balance Sheet for all Users')),
            (!UniversalPlatform.isWeb)
                ? OutlinedButton(
                    onPressed: () {
                      AppUtils.closeApp();
                    },
                    child: const Text('Exit'))
                : Container(),
          ],
        ),
      ),
    );
  }
}
