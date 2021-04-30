import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:tod/Login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'tagcard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<SwipeStackState> _swipeKey = GlobalKey<SwipeStackState>();
  var scafoldkey = new GlobalKey<ScaffoldState>();
  String recent1 = "This is News One";

  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _moveUp() {
    _controller.animateTo(
        _controller.offset + MediaQuery.of(context).size.height,
        curve: Curves.linear,
        duration: Duration(milliseconds: 350));
  }

  _moveDown() {
    _controller.animateTo(
        _controller.offset - MediaQuery.of(context).size.height,
        curve: Curves.linear,
        duration: Duration(milliseconds: 500));
  }

  var lock = 0;
  _scrollListener() {
    if (_controller.offset >= 80 && lock == 0) {
      _moveUp();
      lock = 1;
    }
    if (_controller.offset < 100) {
      lock = 0;
    }
  }

  Widget coroselcard(String img, String recent, String url) {
    return GestureDetector(
      onTap: () {
        launchurl(url);
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.black87, Colors.black26])),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Text(
                  (recent.length > 19)
                      ? recent.substring(0, 20) + ".."
                      : recent,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //API callings
  Future getData() async {
    var response = await http.get(
      "https://todapi.herokuapp.com/dashboard",
    );
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
    return new WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        _moveDown();
      },
      child: new Scaffold(
        key: scafoldkey,
        drawer: new AppDrawer(),
        body: SafeArea(
          child: ListView(
            controller: _controller,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: GestureDetector(
                  onTap: () {
                    scafoldkey.currentState.openDrawer();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        'images/logo2.png',
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                          Text(
                            (dashBoardName.length > 10)
                                ? dashBoardName.substring(0, 10)
                                : dashBoardName,
                            style: TextStyle(fontSize: 30, color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null)
                        return Center(
                          child: Text("loading"),
                        );
                      else
                        return CarouselSlider(
                            items: <Widget>[
                              coroselcard(
                                  snapshot.data[0]['imageurl'],
                                  snapshot.data[0]['title'],
                                  snapshot.data[0]['readurl']),
                              coroselcard(
                                  snapshot.data[1]['imageurl'],
                                  snapshot.data[1]['title'],
                                  snapshot.data[1]['readurl']),
                              coroselcard(
                                  snapshot.data[2]['imageurl'],
                                  snapshot.data[2]['title'],
                                  snapshot.data[2]['readurl']),
                            ],
                            options: CarouselOptions(
                              height: 250,
                              viewportFraction: 0.8,
                              aspectRatio: 2,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ));
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              tag = 'achieve';
                              Navigator.pushNamed(context, 'tagcard');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 15),
                                      child: Text(
                                        "Achievements",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, bottom: 15),
                                          child: FaIcon(
                                            FontAwesomeIcons.trophy,
                                            color: Colors.white60,
                                            size: 60,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        .10,
                                        5
                                      ],
                                      colors: [
                                        Color(0xFF390037),
                                        Color(0xff0CBABA)
                                      ]),
                                ),
                                height:
                                    2 * MediaQuery.of(context).size.height / 10,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              tag = 'notice';
                              Navigator.pushNamed(context, 'tagcard');
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 15),
                                    child: Text(
                                      "Notices",
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 15),
                                        child: FaIcon(
                                          FontAwesomeIcons.solidBell,
                                          color: Colors.white60,
                                          size: 60,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    stops: [
                                      .10,
                                      5
                                    ],
                                    colors: [
                                      Color(0xffA61C31),
                                      Color(0xff3E0C12)
                                    ]),
                              ),
                              height:
                                  2 * MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              tag = 'exam';
                              Navigator.pushNamed(context, 'tagcard');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 15),
                                      child: Text(
                                        "Exams",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, bottom: 15),
                                          child: FaIcon(
                                            FontAwesomeIcons.newspaper,
                                            color: Colors.white60,
                                            size: 60,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        .10,
                                        5
                                      ],
                                      colors: [
                                        Colors.black,
                                        Color(0xff63D471)
                                      ]),
                                ),
                                height:
                                    2 * MediaQuery.of(context).size.height / 10,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              tag = 'no';
                              Navigator.pushNamed(context, 'tagcard');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 15),
                                      child: Text(
                                        "History",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, bottom: 15),
                                          child: FaIcon(
                                            FontAwesomeIcons.hourglassHalf,
                                            color: Colors.white60,
                                            size: 60,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        .10,
                                        5
                                      ],
                                      colors: [
                                        Color(0xFF390037),
                                        Color(0xff0CBABA)
                                      ]),
                                ),
                                height:
                                    2 * MediaQuery.of(context).size.height / 10,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                              child: Center(child: Text("loading..")));
                        } else
                          return SwipeStack(
                            key: _swipeKey,
                            children:
                                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((int index) {
                              return SwiperItem(builder:
                                  (SwiperPosition position, double progress) {
                                return Material(
                                    elevation: 4,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        child: ListView(
                                          children: <Widget>[
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data[index]
                                                              ['imageurl']),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                  snapshot.data[index]['title'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                  snapshot.data[index]['date'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Text(
                                                  snapshot.data[index]
                                                      ['content'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      _swipeKey.currentState
                                                          .rewind();
                                                    },
                                                    child: Text(
                                                      "Previous card",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      launchurl(
                                                          snapshot.data[index]
                                                              ['readurl']);
                                                    },
                                                    child: Text(
                                                      "Read more >",
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )));
                              });
                            }).toList(),
                            visibleCount: 3,
                            stackFrom: StackFrom.Top,
                            translationInterval: 6,
                            scaleInterval: 0.03,
                            historyCount: 10,
                            onEnd: () {
                              setState(() {});
                            },
                            onSwipe: (int index, SwiperPosition position) =>
                                debugPrint("onSwipe $index $position"),
                            onRewind: (int index, SwiperPosition position) =>
                                debugPrint("onRewind $index $position"),
                          );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String authpass;
  Future postData() async {
    EasyLoading.show(
        status: 'verifying..', maskType: EasyLoadingMaskType.black);
    var response = await http.post(
      "https://todapi.herokuapp.com/authpass",
      body: {
        'pass': '$authpass',
      },
    );
    Duration twosec = Duration(seconds: 2);
    if (jsonDecode(response.body)['error'] == 0) {
      EasyLoading.showSuccess("Successful!",
          duration: twosec, maskType: EasyLoadingMaskType.black);
      Navigator.pushNamed(context, "verifynews");
    } else
      EasyLoading.showError(jsonDecode(response.body)['status']);
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 70,
                      ),
                    ),
                    Text(dashBoardName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20)),
                    Text(
                      dashBoardEmail,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: Text(
              "Log out",
              style: TextStyle(fontSize: 25),
            ),
            trailing: FaIcon(FontAwesomeIcons.doorOpen),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'submitnews');
            },
            title: Text(
              "Submit news",
              style: TextStyle(fontSize: 25),
            ),
            trailing: FaIcon(FontAwesomeIcons.penAlt),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        height: 150,
                        child: Form(
                            key: formkey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextFormField(
                                    obscureText: true,
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                      ),
                                      labelText: "Enter password",
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty)
                                        return "Please enter a password.";
                                      return null;
                                    },
                                    onChanged: (String name) {
                                      authpass = name;
                                    },
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.black54,
                                  splashColor: Colors.white24,
                                  child: Text(
                                    "verify",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (formkey.currentState.validate()) {
                                      print("success");
                                      postData();
                                    } else
                                      print("unsuccessful");
                                  },
                                ),
                              ],
                            )),
                      ),
                    );
                  });
            },
            title: Text(
              "Verify",
              style: TextStyle(fontSize: 25),
            ),
            trailing: FaIcon(FontAwesomeIcons.glasses),
          ),
          ListTile(
            title: Text(
              "Dark mode",
              style: TextStyle(fontSize: 25),
            ),
            trailing: FaIcon(FontAwesomeIcons.solidMoon),
          ),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(fontSize: 25),
            ),
            trailing: FaIcon(FontAwesomeIcons.infoCircle),
            onTap: () {
              Navigator.pushNamed(context, 'about');
            },
          ),
        ],
      ),
    );
  }
}
