import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Verifynews extends StatefulWidget {
  @override
  _VerifynewsState createState() => _VerifynewsState();
}

class _VerifynewsState extends State<Verifynews> {
  Future getData() async {
    EasyLoading.show(status: 'Loading..', maskType: EasyLoadingMaskType.black);
    var response = await http.get(
      "https://todapi.herokuapp.com/approvearticles",
    );

    EasyLoading.showSuccess("success");
    List objects = [];
    for (var elements in jsonDecode(response.body)) {
      objects.add(elements);
      //print(elements['_id']);
    }
    return objects;
  }

  Future approveData(String id) async {
    EasyLoading.show(status: 'Updating..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/approvenews",
      body: {
        'id': id,
      },
    );

    Duration twosec = Duration(seconds: 1);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Update Successful!",
          duration: twosec, maskType: EasyLoadingMaskType.black);
    } else
      EasyLoading.showError(jsonDecode(response.body)['status']);
  }

  Future deleteData(String id) async {
    EasyLoading.show(status: 'Deleting..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/deletenews",
      body: {
        'id': id,
      },
    );

    Duration twosec = Duration(seconds: 1);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Delete Successful!",
          duration: twosec, maskType: EasyLoadingMaskType.black);
    } else
      EasyLoading.showError(jsonDecode(response.body)['status']);
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
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  (snapshot.data[index]['imageurl'] != 'null')
                                      ? GestureDetector(
                                          onTap: () {
                                            launchurl(snapshot.data[index]
                                                ['imageurl']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Icon(Icons.image),
                                          ),
                                        )
                                      : Text(""),
                                  (snapshot.data[index]['readurl'] != 'null')
                                      ? GestureDetector(
                                          onTap: () {
                                            launchurl(snapshot.data[index]
                                                ['readurl']);
                                          },
                                          child: Icon(Icons.link))
                                      : Text("")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      approveData(snapshot.data[index]['_id']);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteData(snapshot.data[index]['_id']);
                                    },
                                    child: Text("Decline",
                                        style: TextStyle(color: Colors.red)),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  });
          },
        ),
      ),
    );
  }
}
