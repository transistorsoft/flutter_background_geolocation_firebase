# Android Setup

## Gradle Configuration

### :open_file_folder: **`android/build.gradle`**

```diff
buildscript {
    ext {
        compileSdkVersion   = 28                // Or latest
        targetSdkVersion    = 28                // Or latest
        supportLibVersion   = "1.1.0"           // Or latest
        playServicesLocationVersion = "17.0.0"  // Or Latest
+       firebaseCoreVersion = "17.4.4"          // Or latest
+       firebaseFirestoreVersion = "21.5.0"     // Or latest
    }
    repositories {
        google()
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.3.1'
+       classpath 'com.google.gms:google-services:4.3.3'  // Or latest
    }
}

allprojects {
    repositories {
        google()
        jcenter()
        maven {
            // [required] flutter_background_geolocation
            url "${project(':flutter_background_geolocation').projectDir}/libs"
        }
        maven {
            // [required] background_fetch
            url "${project(':background_fetch').projectDir}/libs"
        }
+       maven {
+           // [required] background_geolocation_firebase
+           url "${project(':background_geolocation_firebase').projectDir}/libs"
+       }
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
