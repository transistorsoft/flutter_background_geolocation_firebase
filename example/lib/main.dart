import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:background_geolocation_firebase/background_geolocation_firebase.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  runApp(new MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled;

  @override
  void initState() {
    _enabled = false;

    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] $location');
    });

    BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
      locationsCollection: "locations"
    ));

    bg.BackgroundGeolocation.ready(bg.Config(
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      stopOnTerminate: false,
      startOnBoot: true
    )).then((bg.State state) {
      setState(() {
        _enabled = state.enabled;
      });

      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }


  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });

    if (enabled) {
      bg.BackgroundGeolocation.start();
    } else {
      bg.BackgroundGeolocation.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const EMPTY_TEXT = Center(child: Text('Waiting for fetch events.  Simulate one.\n [Android] \$ ./scripts/simulate-fetch\n [iOS] XCode->Debug->Simulate Background Fetch'));

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('BackgroundGeolocation Firebase Example', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amberAccent,
          brightness: Brightness.light,
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable),
          ]
        ),
        body: Text("Sample Text"),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.only(left: 5.0, right:5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                ]
            )
          )
        ),
      ),
    );
  }
}
