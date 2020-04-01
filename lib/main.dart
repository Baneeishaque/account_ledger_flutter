import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
// import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:getflutter/getflutter.dart';

import 'http_service.dart';
import 'posts_model.dart';

void main() {
  runApp(AccountLedger());
}

class AccountLedger extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Ledger',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.indigo,
      ),
      home: Login(title: 'Account Ledger : Authentication'),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning that it has a State object (defined below) that contains fields that affect how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: GradientAppBar(

          // Here we take the value from the MyHomePage object that was created by the App.build method, and use it to set our appbar title.

          title: Text(widget.title),
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red])),

      body:
          // FutureBuilder(
          //   future: httpService.getPosts(),
          //   builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          //     if (snapshot.hasData) {
          //       List<Post> posts = snapshot.data;
          //       return ListView(
          //         children: posts
          //             .map(
          //               (Post post) => ListTile(
          //                 title: Text(post.title),
          //                 subtitle: Text("${post.userId}"),
          //               ),
          //             )
          //             .toList(),
          //       );
          //     } else {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),

          LoginForm(),
      // Center(
      //   // Center is a layout widget. It takes a single child and positions it in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and arranges them vertically. By default, it sizes itself to fit its children horizontally, and tries to be as tall as its parent.

      //     // Invoke "debug painting" (press "p" in the console, choose the "Toggle Debug Paint" action from the Flutter Inspector in Android Studio, or the "Toggle Debug Paint" command in Visual Studio Code) to see the wireframe for each widget.

      //     // Column has various properties to control how it sizes itself and how it positions its children. Here we use mainAxisAlignment to center the children vertically; the main axis here is the vertical axis because Columns are vertical (the cross axis would be horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget and allows validation of the form.

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<LoginFormState>.
  final _formKey = GlobalKey<FormState>();

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // BeautyTextfield(
                  //   width: double.maxFinite,
                  //   height: 60,
                  //   duration: Duration(milliseconds: 300),
                  //   inputType: TextInputType.text,
                  //   prefixIcon: Icon(
                  //     Icons.lock_outline,
                  //   ),
                  //   placeholder: "With Suffic Icon",
                  //   onTap: () {
                  //     print('Click');
                  //   },
                  //   onChanged: (t) {
                  //     print(t);
                  //   },
                  //   onSubmitted: (d) {
                  //     print(d.length);
                  //   },
                  //   suffixIcon: Icon(Icons.remove_red_eye),
                  // ),
                  // BeautyTextfield(
                  //   width: double.maxFinite,
                  //   height: 60,
                  //   duration: Duration(milliseconds: 300),
                  //   inputType: TextInputType.text,
                  //   prefixIcon: Icon(
                  //     Icons.lock_outline,
                  //   ),
                  //   placeholder: "Without Suffic Icon",
                  //   onTap: () {
                  //     print('Click');
                  //   },
                  //   onChanged: (t) {
                  //     print(t);
                  //   },
                  //   onSubmitted: (d) {
                  //     print(d.length);
                  //   },
                  // ),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: GradientOutlineInputBorder(
                              focusedGradient: LinearGradient(
                                  colors: [Colors.green, Colors.blue]),
                              unfocusedGradient: LinearGradient(
                                  colors: [Colors.orange, Colors.cyan]),
                            ),
                            labelText: 'Username...'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter username...';
                          }
                          return null;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: GradientOutlineInputBorder(
                              focusedGradient: LinearGradient(
                                  colors: [Colors.green, Colors.blue]),
                              unfocusedGradient: LinearGradient(
                                  colors: [Colors.orange, Colors.cyan]),
                            ),
                            labelText: 'Passcode...'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter passcode...';
                          }
                          return null;
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 11.0, bottom: 16.0),
                    child: GFButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.

                          FutureBuilder(
                            future: httpService.getPosts(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Post>> snapshot) {
                              if (snapshot.hasData) {
                                List<Post> posts = snapshot.data;
                                return ListView(
                                  children: posts
                                      .map(
                                        (Post post) => ListTile(
                                          title: Text(post.title),
                                          subtitle: Text("${post.userId}"),
                                        ),
                                      )
                                      .toList(),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );

                          // GFProgressBar(
                          //     percentage: 0.9,
                          //     width: 100,
                          //     radius: 90,
                          //     backgroundColor: Colors.black26,
                          //     progressBarColor: GFColors.DANGER);

                          // Scaffold.of(context).showSnackBar(
                          //     SnackBar(content: Text('Processing Data...')));
                        }
                      },
                      text: "Submit...",
                      fullWidthButton: true,
                    ),
                    // RaisedButton(
                    //   onPressed: () {
                    //     // Validate returns true if the form is valid, or false otherwise.
                    //     if (_formKey.currentState.validate()) {
                    //       // If the form is valid, display a Snackbar.
                    //       Scaffold.of(context).showSnackBar(
                    //           SnackBar(content: Text('Processing Data...')));
                    //     }
                    //   },
                    //   child: Text('Submit...'),
                    // )
                  )
                ])));
  }
}
