# Android Setup

## Gradle Configuration

### :open_file_folder: **`android/build.gradle`**

- Add the following **required** `maven` repo url:

```diff
allprojects {   // <-- IMPORTANT:  allprojects
    repositories {
        google()
        mavenCentral()
        // [required] flutter_background_geolocation
        maven { url "${project(':flutter_background_geolocation').projectDir}/libs" }
        // [required] background_fetch
        maven { url "${project(':background_fetch').projectDir}/libs" }
+       // [required] background_geolocation_firebase
+       maven { url "${project(':background_geolocation_firebase').projectDir}/libs" }
    }
}
```

- #### If you're using `flutter >= 3.19.0` ([New Android Architecture](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply)):

```diff
+ext {
+    compileSdkVersion   = 34                // or higher / as desired
+    targetSdkVersion    = 34                // or higher / as desired
+    minSdkVersion       = 21                // Required minimum
+    FirebaseSDKVersion  = "33.4.0"          // or as desired.
+}
```

- #### Otherwise for `flutter < 3.19.0` (Old Android Architecture):

```diff

buildscript {
    ext.kotlin_version = '1.3.0' // Must use 1.3.0 OR HIGHER
+   ext {
+       compileSdkVersion   = 34                // or higher / as desired
+       targetSdkVersion    = 34                // or higher / as desired
+       minSdkVersion       = 21                // Required minimum
+       FirebaseSDKVersion  = "33.4.0"          // or as desired.
+   }
}
```

> [!NOTE]  
> the param __`ext.FirebaseSdkVersion`__ controls the imported version of the *Firebase SDK* (`com.google.firebase:firebase-bom`).  Consult the [Firebase Release Notes](https://firebase.google.com/support/release-notes/android?_gl=1*viqpog*_up*MQ..*_ga*MTE1NjI2MDkuMTcyOTA4ODY0MQ..*_ga_CW55HF8NVT*MTcyOTA4ODY0MS4xLjAuMTcyOTA4ODY0MS4wLjAuMA..#latest_sdk_versions) to determine the latest version of the *Firebase* SDK



### :open_file_folder: **`android/settings.gradle`**
- Add the `google-services` plugin (if you haven't already):

```diff
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.1" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
+   id 'com.google.gms.google-services' version '4.3.15' apply false    // Or any desired version.
}
```

### :open_file_folder: **`android/app/build.gradle`**
- In your app level `build.gradle`, apply the `google-services` plugin:

```diff
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
+   id "com.google.gms.google-services"
}
```

### :open_file_folder: **`google-services.json`**

Download your `google-services.json` from the [*Firebase Console*](https://console.firebase.google.com).  Copy the file to your `android/app` folder.

## License Key

If you've [purchased a license](https://shop.transistorsoft.com/products/background-geolocation-firebase), add your license key to the `AndroidManifest.xml`.  If you haven't purchased a key, the SDK is fully functional in debug builds so you can try [before you buy](https://shop.transistorsoft.com/products/background-geolocation-firebase).

:open_file_folder: **`android/app/src/main/AndroidManifest.xml`**

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.transistorsoft.backgroundgeolocation.react">

  <application
    android:name=".MainApplication"
    android:allowBackup="true"
    android:label="@string/app_name"
    android:icon="@mipmap/ic_launcher"
    android:theme="@style/AppTheme">
    
    <!-- Flutter Background Geolocation License -->
    <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_BACKGROUND_GEOLOCATION_LICENSE" />
    
+   <!-- Flutter Background Geolocation Firebase licence -->
+   <meta-data android:name="com.transistorsoft.firebaseproxy.license" android:value="YOUR_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>

```

:information_source: [Purchase a License](https://shop.transistorsoft.com/products/background-geolocation-firebase)
