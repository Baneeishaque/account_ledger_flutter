import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/progress_bar/gf_progress_bar.dart';

class LoginForm3 extends StatefulWidget {
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
