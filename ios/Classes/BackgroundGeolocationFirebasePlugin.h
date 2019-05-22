#import <Flutter/Flutter.h>

@interface BackgroundGeolocationFirebasePlugin : NSObject<FlutterPlugin>

@property (nonatomic) NSString* locationsCollection;
@property (nonatomic) NSString* geofencesCollection;
@property (nonatomic) BOOL updateSingleDocument;

@end
