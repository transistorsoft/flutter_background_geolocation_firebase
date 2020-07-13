# CHANGELOG

## 0.2.0 - 2020-07-13
* [Fixed][Android] `com.android.tools.build:gradle:4.0.0` no longer allows "*direct local aar dependencies*".  The Android Setup now requires a custom __`maven url`__ to be added to your app's root __`android/build.gradle`__:

```diff
allprojects {
    repositories {
        google()
        jcenter()
+       maven {
+           // [required] background_geolocation_firebase
+           url "${project(':background_geolocation_firebase').projectDir}/libs"
+       }
    }
}
```

## 0.1.0 &mdash; 2019-08-20
* Release to pub.dev

## 0.0.2 &mdash; 2019-05-24
* [Fixed] Android issue not registering plugin in terminated state.

## 0.0.1 &mdash; 2019-05-23

* First working implementation
