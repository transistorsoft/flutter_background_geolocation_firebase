import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const _PLUGIN_PATH =
    "com.transistorsoft/flutter_background_geolocation_firebase";
const _METHOD_CHANNEL_NAME = "$_PLUGIN_PATH/methods";

/// Configuration
///
/// ```dart
/// BackgroundFetch.configure(BackgroundFetchConfig(
///   minimumFetchInterval: 15,
///   stopOnTerminate: false,
///   startOnBoot: true,
///   enableHeadless: true
/// ), () {
///   // This callback is typically fired every 15 minutes while in the background.
///   print('[BackgroundFetch] Event received.');
///   // IMPORTANT:  You must signal completion of your fetch task or the OS could
///   // punish your app for spending much time in the background.
///   BackgroundFetch.finish();
/// })
///
class BackgroundGeolocationFirebaseConfig {
  /// TODO
  ///
  String locationsCollection;

  /// TODO
  String geofencesCollection;

  /// TODO
  bool updateSingleDocument;

  BackgroundGeolocationFirebaseConfig(
      {this.locationsCollection,
      this.geofencesCollection,
      this.updateSingleDocument});

  Map toMap() {
    Map config = {};
    if (locationsCollection != null)
      config['locationsCollection'] = locationsCollection;
    if (geofencesCollection != null)
      config['geofencesCollection'] = geofencesCollection;
    if (updateSingleDocument != null)
      config['updateSingleDocument'] = updateSingleDocument;
    return config;
  }
}

/// BackgroundGeolocationFirebase API
///
///
class BackgroundGeolocationFirebase {
  static const MethodChannel _methodChannel =
      const MethodChannel(_METHOD_CHANNEL_NAME);

  /// Configures the plugin's [BackgroundGeoloationFirebaseConfig]
  ///
  /// ```dart
  /// ```
  static Future<bool> configure(BackgroundGeolocationFirebaseConfig config) {
    Completer completer = new Completer<bool>();

    _methodChannel
        .invokeMethod('configure', config.toMap())
        .then((dynamic status) {
      completer.complete(status);
    }).catchError((dynamic e) {
      completer.completeError(e.details);
    });

    return completer.future;
  }
}
