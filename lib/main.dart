import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:RecordSeek/slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecordSeek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Color(0xfFFFFFF)
      ),
      home: MyHomePage(title: 'Instructions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _intentDataStreamSubscription;
  List<Slide> slides = new List();
  Function goToTab;

  @override
  void initState() {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          print('here i am');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SliderPage(value),
              ));
        }, onError: (err) {
          print("getLinkStream error: $err");
          Navigator.pop(context);
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      print('there i am');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SliderPage(value),
          ));
    });
    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: CircularProgressIndicator())));
  }
}
