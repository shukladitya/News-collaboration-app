import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

String dashBoardName;
String dashBoardEmail;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future postData() async {
    EasyLoading.show(
        status: 'Signing in..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/login",
      body: {
        'email': email,
        'password': password,
      },
    );
    Duration twosec = Duration(seconds: 2);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Log in Successful!",
          duration: twosec, maskType: EasyLoadingMaskType.black);
      dashBoardName = jsonDecode(response.body)['name'];
      dashBoardEmail = jsonDecode(response.body)['email'];
      Navigator.pushNamed(context, "dashboard");
    } else
      EasyLoading.showError(jsonDecode(response.body)['status']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/background.jpg"),
          ),
        ),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/logo.png"),
                backgroundColor: Colors.white,
              ),
              Text(
                "Sign in",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white)),
                  validator: (String value) {
                    if (value.isEmpty) return "Please enter valid email.";
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please a valid Email';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    email = value;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.white,
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please Enter a Password';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    password = value;
                  },
                ),
              ),
              RaisedButton(
                color: Colors.black54,
                splashColor: Colors.white24,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                onPressed: () {
                  if (formkey.currentState.validate()) {
                    postData();
                  } else
                    print("unsuccessful");
                },
              ),
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'signup');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign up   ",
                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 17,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
