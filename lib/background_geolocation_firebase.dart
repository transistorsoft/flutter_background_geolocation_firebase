import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const _PLUGIN_PATH =
    "com.transistorsoft/flutter_background_geolocation_firebase";
const _METHOD_CHANNEL_NAME = "$_PLUGIN_PATH/methods";

const _BACKGROUND_GEOLOCATION_PLUGIN_PATH =
    "com.transistorsoft/flutter_background_geolocation";
const _BACKGROUND_GEOLOCATION_METHOD_CHANNEL_NAME =
    "$_BACKGROUND_GEOLOCATION_PLUGIN_PATH/methods";

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
  /// The collection name to post location events to.  Defaults to `"locations"`.
  ///
  /// ```dart
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/locations'
  /// ));
  ///
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/locations'
  /// ));
  ///
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/routes/456/locations'
  /// ));
  /// ```
  ///
  String locationsCollection;

  /// The collection name to post geofence events to.  Defaults to `"geofences"`.
  ///
  /// ```dart
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   geofencesCollection: '/geofences'
  /// ));
  ///
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/geofences'
  /// ));
  ///
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/routes/456/geofences'
  /// ));
  /// ```
  String geofencesCollection;

  /// Instruct the plugin to update a single document in Firebase rather than creating a new document for each location / geofence.
  ///
  /// In this case, you would presumably implement a Firebase Function to deal with updates upon this single document and store the location in some other collection as desired. If this is your use-case, you'll also need to ensure you configure your `ocationsCollection` / `geofencesCollection` accordingly with an even number of "parts", taking the form /collection_name/document_id, eg:
  ///
  /// ```dart
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/locations/latest'  // <-- 2 "parts":  even
  /// ));
  ///
  /// // or
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/routes/456/the_location'  // <-- 4 "parts":  even
  /// ));
  ///
  /// // Don't use an odd number of "parts"
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: '/users/123/latest_location'  // <-- 3 "parts": odd!!  No!
  /// ));
  /// ```
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
/// Firebase Proxy for [Flutter Background Geolocation](https://github.com/transistorsoft/flutter_background_geolocation).  The plugin will automatically post locations to your own Firestore database, overriding the `flutter_background_geolocation` plugin's SQLite / HTTP services.
///
class BackgroundGeolocationFirebase {
  static const MethodChannel _methodChannel =
      const MethodChannel(_METHOD_CHANNEL_NAME);

  static const MethodChannel _backgroundGeolocationMethodChannel =
      const MethodChannel(_BACKGROUND_GEOLOCATION_METHOD_CHANNEL_NAME);

  /// Configures the plugin's [BackgroundGeoloationFirebaseConfig]
  ///
  /// ```dart
  /// // 1.  First configure the Firebase Adapter.
  /// BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
  ///   locationsCollection: "locations",
  ///   geofencesCollection: "geofences",
  ///   updateSingleDocument: false
  /// ));
  ///
  /// // 2.  Configure BackgroundGeolocation as usual.
  /// bg.BackgroundGeolocation.ready(bg.Config(
  ///   debug: true,
  ///   logLevel: bg.Config.LOG_LEVEL_VERBOSE,
  ///   stopOnTerminate: false,
  ///   startOnBoot: true
  /// )).then((bg.State state) {
  ///   if (!state.enabled) {
  ///     bg.BackgroundGeolocation.start();
  ///   }
  /// ));
  /// ```
  static Future<bool> configure(BackgroundGeolocationFirebaseConfig config) {
    Completer completer = new Completer<bool>();

    _methodChannel
        .invokeMethod('configure', config.toMap())
        .then((dynamic status) {
      completer.complete(status);
    }).catchError((dynamic e) {
      completer.completeError(e);
    });

    _backgroundGeolocationMethodChannel.invokeMethod(
        'registerPlugin', 'firebaseproxy');

    return completer.future;
  }
}
