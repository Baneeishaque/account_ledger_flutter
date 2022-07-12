import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/colors/gf_color.dart';

class LoginForm3 extends StatefulWidget {
  const LoginForm3({super.key});

  @override
  LoginForm3State createState() {
    return LoginForm3State();
  }
}

class LoginForm3State extends State<LoginForm3> {
  @override
  Widget build(BuildContext context) {
    return GFProgressBar(
        percentage: 1,
        width: 100,
        radius: 90,
        backgroundColor: Colors.black26,
        progressBarColor: GFColors.DANGER);
  }
}
