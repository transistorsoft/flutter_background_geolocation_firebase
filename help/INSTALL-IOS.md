# iOS Setup

### :open_file_folder: Open your **`AppDelegate.m`** or **`AppDelegate.swift`**:


#### :open_file_folder: __`AppDelegate.m`__
```diff
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

+@import FirebaseCore

@implementation AppDelegate

 - (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
+ [FIRApp configure];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

#### :open_file_folder: __`AppDelgate.swift`__:

```diff
import UIKit
import Flutter
+import FirebaseCore;

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
+   FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```


### **`Google-Services-Info.plist`**

From your [*Firebase Console*](https://console.firebase.google.com), copy your downloaded `Google-Services-Info.plist` file into your application:

![](https://dl.dropboxusercontent.com/s/4s7kfa6quusqk7i/Google-Services.plist.png?dl=1)
