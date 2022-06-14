// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eindproject/Globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _fieldData = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 844;
    if (!isTablet) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Your exercises",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowPR(
                                    exercises: snapshot,
                                    k: key,
                                  ),
                                ),
                              ).then((value) => setState(() {}));
                            },
                            child: Center(
                              child: Container(
                                  margin:
                                      EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  width: 300,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Color(0xff1e90ff),
                                          width: 3.0)),
                                  child: Center(
                                    child: Text(
                                      key,
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e90ff)),
                                    ),
                                  )),
                            ));
                      },
                    );
                  }
                },
              )),
              FutureBuilder(
                  future: hasNetwork(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data == true) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              width: 225,
                              padding: EdgeInsets.only(left: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xff5F5F5F), width: 3)),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Color(0xff1e90ff), fontSize: 20.0),
                                decoration: InputDecoration(
                                    hintText: 'New exercise',
                                    hintStyle: TextStyle(fontSize: 20.0)),
                                onChanged: (String value) {
                                  try {
                                    _fieldData = value;
                                  } catch (exception) {
                                    _fieldData = "";
                                  }
                                },
                              ),
                            ),
                            InkWell(
                                onTap: () async {
                                  if (_fieldData != "") {
                                    globals.exercises
                                        .add({
                                          'name': _fieldData,
                                          'reps': 0,
                                          'weight': 0
                                        })
                                        .then((value) => debugPrint(
                                            "new lift addes succesfully"))
                                        .catchError((error) => debugPrint(
                                            "Failed to add lift: $error"));
                                  }
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (_) => false);
                                },
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    padding: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            color: Color(0xff5F5F5F),
                                            width: 3.0)),
                                    child: Center(
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Color(0xff5F5F5F),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )))
                          ],
                        );
                      }
                    }
                    return Container(
                      padding: EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 2, color: Color(0xff5F5F5F)))),
                      child: Center(
                          child: Text(
                        "No internet",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color(0xff1e90ff),
                            fontWeight: FontWeight.bold),
                      )),
                    );
                  }),
            ],
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: Text(
              "Your exercises",
              style: TextStyle(fontSize: 60.0),
            ),
            backgroundColor: Color(0xff1e90ff),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: FutureBuilder<Map<String, dynamic>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 4 / 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 30,
                            maxCrossAxisExtent: 800),
                        padding: EdgeInsets.only(top: 10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String key = snapshot.data!.keys.elementAt(index);
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowPR(
                                      exercises: snapshot,
                                      k: key,
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                              child: Center(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    width: 700,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            color: Color(0xff1e90ff),
                                            width: 3.0)),
                                    child: Center(
                                      child: Text(
                                        key,
                                        style: TextStyle(
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1e90ff)),
                                      ),
                                    )),
                              ));
                        },
                      ),
                    );
                  }
                },
              )),
              FutureBuilder(
                  future: hasNetwork(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data == true) {
                        return Container(
                          padding: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 5, color: Color(0xff5F5F5F)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15.0),
                                width: 500,
                                padding: EdgeInsets.only(left: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xff1e90ff), width: 3)),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      color: Color(0xff1e90ff),
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: 'New exercise',
                                      hintStyle: TextStyle(fontSize: 40.0)),
                                  onChanged: (String value) {
                                    try {
                                      _fieldData = value;
                                    } catch (exception) {
                                      _fieldData = "";
                                    }
                                  },
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (_fieldData != "") {
                                      globals.exercises
                                          .add({
                                            'name': _fieldData,
                                            'reps': 0,
                                            'weight': 0
                                          })
                                          .then(
                                              (value) => debugPrint("new lift"))
                                          .catchError((error) => debugPrint(
                                              "Failed to add lift: $error"));
                                    }
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/', (_) => false);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 15.0),
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      width: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: Color(0xff1e90ff),
                                              width: 3.0)),
                                      child: Center(
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                              fontSize: 45.0,
                                              color: Color(0xff1e90ff),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )))
                            ],
                          ),
                        );
                      }
                    }
                    return Container(
                      padding: EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 5, color: Color(0xff5F5F5F)))),
                      child: Center(
                          child: Text(
                        "No internet",
                        style: TextStyle(
                            fontSize: 45.0,
                            color: Color(0xff1e90ff),
                            fontWeight: FontWeight.bold),
                      )),
                    );
                  }),
            ],
          ));
    }
  }
}

class ShowPR extends StatefulWidget {
  AsyncSnapshot<Map<String, dynamic>> exercises;

  String k;

  ShowPR({Key? key, required this.exercises, required this.k})
      : super(key: key);

  @override
  State<ShowPR> createState() => _ShowPRState();
}

class _ShowPRState extends State<ShowPR> {
  int _repField = -1;
  int _weightField = -1;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide >= 844;
    if (!isTablet) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.k,
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff1e90ff),
          ),
          body: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border:
                            Border.all(color: Color(0xff5F5F5F), width: 3.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 1),
                                  child: Flexible(
                                    child: Text(
                                      "Current PR",
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 25.0),
                                      child: Text(
                                        "Weight",
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(),
                                      child: Text(
                                        "${widget.exercises.data![widget.k]['weight']} Kg"
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1e90ff)),
                                      ))
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 25.0),
                                      child: Text(
                                        "Reps",
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(),
                                      child: Text(
                                        "${widget.exercises.data![widget.k]['reps']} rep(s)"
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1e90ff)),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ]),
                  )),
                  if (globals.dataSource == "Api") ...[
                    Center(
                        child: Container(
                      margin: EdgeInsets.only(top: 50.0),
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border:
                              Border.all(color: Color(0xff5F5F5F), width: 3.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Container(
                                margin:
                                    EdgeInsets.only(bottom: 10.0, top: 10.0),
                                child: Text("New PR",
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 110,
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color(0xff1e90ff), width: 1)),
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                    style: TextStyle(
                                        color: Color(0xff1e90ff),
                                        fontSize: 25.0),
                                    decoration: InputDecoration(
                                      hintText: 'weight',
                                    ),
                                    onChanged: (String value) {
                                      try {
                                        _weightField = int.parse(value);
                                      } catch (exception) {
                                        _weightField = -1;
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: 110,
                                  padding: EdgeInsets.only(left: 15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color(0xff1e90ff), width: 1)),
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                    style: TextStyle(
                                        color: Color(0xff1e90ff),
                                        fontSize: 25.0),
                                    decoration:
                                        InputDecoration(hintText: 'reps'),
                                    onChanged: (String value) {
                                      try {
                                        _repField = int.parse(value);
                                      } catch (exception) {
                                        _repField = -1;
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  if (_repField > 0 && _weightField > 0) {
                                    globals.exercises
                                        .where("name", isEqualTo: widget.k)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) => {
                                              if (querySnapshot.docs.length ==
                                                  1)
                                                {
                                                  querySnapshot.docs
                                                      .forEach((doc) {
                                                    doc.reference.update({
                                                      'reps': _repField,
                                                      'weight': _weightField
                                                    });
                                                  })
                                                }
                                            });
                                    setState(() {
                                      widget.exercises.data![widget.k]['reps'] =
                                          _repField;
                                      widget.exercises.data![widget.k]
                                          ['weight'] = _weightField;
                                    });
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    width: 150,
                                    height: 42,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            color: Color(0xff1e90ff),
                                            width: 3.0)),
                                    child: Center(
                                      child: Text(
                                        "Update PR",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1e90ff)),
                                      ),
                                    )))
                          ]),
                    )),
                  ],
                ],
              ),
            ],
          ));
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(
                Icons.arrow_back,
                size: 50.0,
              )),
          toolbarHeight: 80,
          title: Text(
            widget.k,
            style: TextStyle(fontSize: 60.0),
          ),
          backgroundColor: Color(0xff1e90ff),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                    child: Container(
                  margin: EdgeInsets.only(top: 200.0),
                  width: 500,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Color(0xff5F5F5F), width: 5.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 1),
                              child: Text(
                                "Current PR",
                                style: TextStyle(
                                    fontSize: 70.0,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 25.0),
                                    child: Text(
                                      "Weight",
                                      style: TextStyle(
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(),
                                    child: Text(
                                      "${widget.exercises.data![widget.k]['weight']} Kg"
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e90ff)),
                                    ))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 25.0),
                                    child: Text(
                                      "Reps",
                                      style: TextStyle(
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(),
                                    child: Text(
                                      "${widget.exercises.data![widget.k]['reps']} rep(s)"
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e90ff)),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ]),
                )),
                if (globals.dataSource == "Api") ...[
                  Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    width: 500,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border:
                            Border.all(color: Color(0xff5F5F5F), width: 5.0)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                              child: Text("New PR",
                                  style: TextStyle(
                                      fontSize: 70.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 180,
                                padding: EdgeInsets.only(left: 15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xff1e90ff), width: 3)),
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  style: TextStyle(
                                      color: Color(0xff1e90ff), fontSize: 35.0),
                                  decoration: InputDecoration(
                                    hintText: 'weight',
                                  ),
                                  onChanged: (String value) {
                                    try {
                                      _weightField = int.parse(value);
                                    } catch (exception) {
                                      _weightField = -1;
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: 180,
                                padding: EdgeInsets.only(left: 15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xff1e90ff), width: 3)),
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  style: TextStyle(
                                      color: Color(0xff1e90ff), fontSize: 35.0),
                                  decoration: InputDecoration(hintText: 'reps'),
                                  onChanged: (String value) {
                                    try {
                                      _repField = int.parse(value);
                                    } catch (exception) {
                                      _repField = -1;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                if (_repField > 0 && _weightField > 0) {
                                  globals.exercises
                                      .where("name", isEqualTo: widget.k)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) => {
                                            if (querySnapshot.docs.length == 1)
                                              {
                                                querySnapshot.docs
                                                    .forEach((doc) {
                                                  doc.reference.update({
                                                    'reps': _repField,
                                                    'weight': _weightField
                                                  });
                                                })
                                              }
                                          });
                                  setState(() {
                                    widget.exercises.data![widget.k]['reps'] =
                                        _repField;
                                    widget.exercises.data![widget.k]['weight'] =
                                        _weightField;
                                  });
                                }
                              },
                              child: Container(
                                  margin:
                                      EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  width: 250,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                          color: Color(0xff1e90ff),
                                          width: 5.0)),
                                  child: Center(
                                    child: Text(
                                      "Update PR",
                                      style: TextStyle(
                                          fontSize: 35.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1e90ff)),
                                    ),
                                  )))
                        ]),
                  )),
                ],
              ],
            ),
          ],
        ));
    ;
  }
}

Future<Map<String, dynamic>> getData() async {
  globals.prefs = await SharedPreferences.getInstance();

  if (await hasNetwork()) {
    globals.dataSource = "Api";
    await Firebase.initializeApp();

    globals.exercises = FirebaseFirestore.instance.collection('exercises');
    QuerySnapshot querySnapshot = await globals.exercises.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // ignore: prefer_for_elements_to_map_fromiterable
    Map<String, dynamic> map = Map.fromIterable(allData,
        key: (item) => item['name'],
        value: (item) => {'reps': item['reps'], 'weight': item['weight']});

    globals.prefs.setString('exercises', jsonEncode(map));

    return map;
  }
  globals.dataSource = "cache";
  try {
    String? raw = globals.prefs.getString('exercises');
    if (raw != null) {
      return jsonDecode(raw);
    }
  } catch (exception) {
    print("catch probleem: $exception");
    return <String, dynamic>{};
  }
  throw (exception) {
    print("throw probleem: $exception");
    return <String, dynamic>{};
  };
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
