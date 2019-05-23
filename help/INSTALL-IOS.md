# iOS Setup

### :open_file_folder: **`AppDelegate.m`**

```diff
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

+#import <Firebase/Firebase.h>

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

### **`Google-Services-Info.plist`**

From your [*Firebase Console*](https://console.firebase.google.com), copy your downloaded `Google-Services-Info.plist` file into your application:

![](https://dl.dropboxusercontent.com/s/4s7kfa6quusqk7i/Google-Services.plist.png?dl=1)
