# Android Setup

## Gradle Configuration

### :open_file_folder: **`android/build.gradle`**

```diff
buildscript {
    ext {
        compileSdkVersion   = 28
        targetSdkVersion    = 28
        supportLibVersion   = "1.0.2"
        playServicesLocationVersion = "16.0.0"
+       firebaseCoreVersion = "16.0.9"      // Or latest
+       firebaseFirestoreVersion = "19.0.0" // Or latest
    }
    repositories {
        google()
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.3.1'
+       classpath 'com.google.gms:google-services:4.2.0'  // Or latest
    }
}
```

### :open_file_folder: **`android/app/build.gradle`**

```diff

dependencies {
    .
    .
    .
}

+apply plugin: 'com.google.gms.google-services'
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

    <!-- Flutter Background Geolocation Firebase licence -->
+   <meta-data android:name="com.transistorsoft.firebaseproxy.license" android:value="YOUR_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>

```

:information_source: [Purchase a License](https://shop.transistorsoft.com/products/background-geolocation-firebase)
