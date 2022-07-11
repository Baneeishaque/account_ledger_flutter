import 'package:flutter/material.dart';
import 'package:beauty_textfield/beauty_textfield.dart';

class LoginForm2 extends StatefulWidget {
  @override
  LoginForm2State createState() {
    return LoginForm2State();
  }
}

class LoginForm2State extends State<LoginForm2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext buildContext) {
      return Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BeautyTextfield(
                  width: double.maxFinite,
                  height: 60,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  placeholder: "With Suffix Icon",
                  onTap: () {
                    print('Click');
                  },
                  onChanged: (t) {
                    print(t);
                  },
                  onSubmitted: (d) {
                    print(d.length);
                  },
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
                BeautyTextfield(
                  width: double.maxFinite,
                  height: 60,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  placeholder: "Without Suffix Icon",
                  onTap: () {
                    print('Click');
                  },
                  onChanged: (t) {
                    print(t);
                  },
                  onSubmitted: (d) {
                    print(d.length);
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    Scaffold.of(buildContext).showSnackBar(
                        SnackBar(content: Text('Processing Data...')));
                  },
                  child: Text('Submit...'),
                )
              ]));
    }));
  }
}
