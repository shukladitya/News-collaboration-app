import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

var tag = 'no';

class Tagcard extends StatefulWidget {
  @override
  _TagcardState createState() => _TagcardState();
}

class _TagcardState extends State<Tagcard> {
  Future getData() async {
    EasyLoading.show(status: 'Loading..', maskType: EasyLoadingMaskType.black);
    var response;
    if (tag != 'no')
      response = await http.post("https://todapi.herokuapp.com/tagnews", body: {
        'tag': tag,
      });
    else
      response = await http.get("https://todapi.herokuapp.com/tagnewsall");

    EasyLoading.showSuccess("success");
    List objects = [];
    for (var elements in jsonDecode(response.body)) {
      objects.add(elements);
    }
    return objects;
  }

  Future launchurl(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: true,
          forceWebView: true,
          headers: {'header_key': 'header_value'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("loading..")));
            } else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data[index]['imageurl']),
                                  fit: BoxFit.cover)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 25),
                          title: Text(
                            snapshot.data[index]['title'],
                            style: TextStyle(fontSize: 30),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data[index]['content'],
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      launchurl(
                                          snapshot.data[index]['readurl']);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        'Read more >',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  });
          },
        ),
      ),
    );
  }
}
