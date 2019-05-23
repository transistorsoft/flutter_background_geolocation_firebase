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
  String _locationJSON;
  JsonEncoder _encoder = new JsonEncoder.withIndent('  ');

  @override
  void initState() {
    _enabled = false;
    _locationJSON = "Toggle the switch to start tracking.";

    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] $location');
      setState(() {
        _locationJSON = _encoder.convert(location.toMap());
      });
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        identifier: location.timestamp,
        radius: 200,
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        notifyOnEntry: true,
        notifyOnExit: true
      ));
    });

    BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
      locationsCollection: "locations",
      geofencesCollection: "geofences",
      updateSingleDocument: false
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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('BGGeo Firebase Example', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amberAccent,
          brightness: Brightness.light,
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable),
          ]
        ),
        body: Text(_locationJSON),
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
