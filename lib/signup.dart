import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String userName;
  String useremail;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confpassword = TextEditingController();

  Future postData() async {
    EasyLoading.show(
        status: 'Signing up..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/newuser",
      body: {
        'name': '$userName',
        'email': '$useremail',
        'password': '${password.text}'
      },
    );
    Duration twosec = Duration(seconds: 2);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Sign up Successful!",
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
                "Sign up",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
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
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.white)),
                  validator: (String value) {
                    if (value.isEmpty) return "Please enter a name.";
                    return null;
                  },
                  onChanged: (String name) {
                    userName = name;
                  },
                ),
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
                  onChanged: (String email) {
                    useremail = email;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: TextFormField(
                  controller: password,
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
                    if (value.length < 4) {
                      return 'At least  4 characters';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                child: TextFormField(
                  controller: confpassword,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.white,
                    ),
                    labelText: "Confirm Password",
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
                    if (password.text != confpassword.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              RaisedButton(
                color: Colors.black54,
                splashColor: Colors.white24,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                onPressed: () {
                  if (formkey.currentState.validate()) {
                    print("success");
                    postData();
                  } else
                    print("unsuccessful");
                },
              ),
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Back   ",
                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    ),
                    Icon(
                      Icons.arrow_back_ios,
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
