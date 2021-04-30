import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tod/Login.dart';
import 'package:http/http.dart' as http;

var now = new DateTime.now();
final formatter = new DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

class Submitnews extends StatefulWidget {
  @override
  _SubmitnewsState createState() => _SubmitnewsState();
}

class _SubmitnewsState extends State<Submitnews> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  String Newstitle;
  // ignore: non_constant_identifier_names
  String Newsimageurl;
  // ignore: non_constant_identifier_names
  String Newscontent;
  // ignore: non_constant_identifier_names
  String Newslinkurl;
  // ignore: non_constant_identifier_names
  String Newstag = 'no';
  Future postData() async {
    EasyLoading.show(
        status: 'Submitting..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/newarticle",
      body: {
        'date': '$formattedDate',
        'title': '$Newstitle',
        'imageurl': '$Newsimageurl',
        'content': '$Newscontent',
        'readurl': '$Newslinkurl',
        'email': '$dashBoardEmail',
        'tag': '$Newstag'
      },
    );
    Duration twosec = Duration(seconds: 2);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Submit Successful!",
          duration: twosec, maskType: EasyLoadingMaskType.black);
      Navigator.pop(context);
    } else
      EasyLoading.showError(jsonDecode(response.body)['status']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                "News",
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Date:$formattedDate",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "By:$dashBoardEmail",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.title,
                      color: Colors.black,
                    ),
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.black)),
                validator: (String value) {
                  if (value.isEmpty) return "Please enter a title.";
                  return null;
                },
                onChanged: (String value) {
                  Newstitle = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    labelText: "Image Url",
                    labelStyle: TextStyle(color: Colors.black)),
                onChanged: (String value) {
                  Newsimageurl = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 17),
              child: TextField(
                decoration: InputDecoration(hintText: "Write news here..."),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (String value) {
                  Newscontent = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.link,
                      color: Colors.black,
                    ),
                    labelText: "Read more url",
                    labelStyle: TextStyle(color: Colors.black)),
                onChanged: (String value) {
                  Newslinkurl = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35, right: 20, top: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: FaIcon(FontAwesomeIcons.hashtag),
                  ),
                  DropdownButton(
                    value: Newstag,
                    hint: Icon(
                      Icons.folder_open,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'No tag',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        value: 'no',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Achievement',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        value: 'achieve',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Notice',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        value: 'notice',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Exam',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        value: 'exam',
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        Newstag = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: RaisedButton(
                color: Colors.black54,
                splashColor: Colors.white24,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                child: Text(
                  "Submit",
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
            ),
          ],
        ),
      ),
    );
  }
}
