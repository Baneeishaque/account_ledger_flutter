import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:gradient_input_border/gradient_input_border.dart';

import 'http_service.dart';
import 'posts_model.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                          if (value!.isEmpty) {
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
                          if (value!.isEmpty) {
                            return 'Please enter passcode...';
                          }
                          return null;
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 11.0, bottom: 16.0),
                    child: GFButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FutureBuilder(
                            future: httpService.getPosts(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Post>> snapshot) {
                              if (snapshot.hasData) {
                                List<Post> posts = snapshot.data!;
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
                        }
                      },
                      text: "Submit...",
                      fullWidthButton: true,
                    ),
                  )
                ])));
  }
}
