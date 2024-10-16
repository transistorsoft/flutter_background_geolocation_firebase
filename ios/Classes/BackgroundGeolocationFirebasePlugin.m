#import "BackgroundGeolocationFirebasePlugin.h"

@import FirebaseCore;
@import FirebaseFirestore;

static NSString *const PLUGIN_PATH = @"com.transistorsoft/flutter_background_geolocation_firebase";
static NSString *const METHOD_CHANNEL_NAME      = @"methods";

static NSString *const ACTION_CONFIGURE = @"configure";

static NSString *const PERSIST_EVENT                = @"TSLocationManager:PersistEvent";

static NSString *const FIELD_LOCATIONS_COLLECTION = @"locationsCollection";
static NSString *const FIELD_GEOFENCES_COLLECTION = @"geofencesCollection";
static NSString *const FIELD_UPDATE_SINGLE_DOCUMENT = @"updateSingleDocument";

static NSString *const DEFAULT_LOCATIONS_COLLECTION = @"locations";
static NSString *const DEFAULT_GEOFENCES_COLLECTION = @"geofences";


@implementation BackgroundGeolocationFirebasePlugin {
    BOOL isRegistered;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSString *methodPath = [NSString stringWithFormat:@"%@/%@", PLUGIN_PATH, METHOD_CHANNEL_NAME];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:methodPath binaryMessenger:[registrar messenger]];

    BackgroundGeolocationFirebasePlugin* instance = [[BackgroundGeolocationFirebasePlugin alloc] init];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(instancetype) init {
    self = [super init];
    if (self) {
        isRegistered = NO;
        _locationsCollection = DEFAULT_LOCATIONS_COLLECTION;
        _geofencesCollection = DEFAULT_GEOFENCES_COLLECTION;
        _updateSingleDocument = NO;
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([self method:call.method is:ACTION_CONFIGURE]) {
        [self configure:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void) configure:(NSDictionary*)config result:(FlutterResult)result {
    if (config[FIELD_LOCATIONS_COLLECTION]) {
        _locationsCollection = config[FIELD_LOCATIONS_COLLECTION];
    }
    if (config[FIELD_GEOFENCES_COLLECTION]) {
        _geofencesCollection = config[FIELD_GEOFENCES_COLLECTION];
    }
    if (config[FIELD_UPDATE_SINGLE_DOCUMENT]) {
        _updateSingleDocument = [config[FIELD_UPDATE_SINGLE_DOCUMENT] boolValue];
    }

    if (!isRegistered) {
        isRegistered = YES;
        
        // TODO make configurable.
        FIRFirestore *db = [FIRFirestore firestore];
        FIRFirestoreSettings *settings = [db settings];
        [db setSettings:settings];

        [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(onPersist:)
            name:PERSIST_EVENT
            object:nil];
    }
    result(@(YES));
}

-(void) onPersist:(NSNotification*)notification {
    NSDictionary *data = notification.object;
    NSString *collectionName = (data[@"location"][@"geofence"]) ? _geofencesCollection : _locationsCollection;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        FIRFirestore *db = [FIRFirestore firestore];
        // Add a new document with a generated ID
        if (!self.updateSingleDocument) {
            __block FIRDocumentReference *ref = [[db collectionWithPath:collectionName] addDocumentWithData:notification.object completion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error adding document: %@", error);
                } else {
                    NSLog(@"Document added with ID: %@", ref.documentID);
                }
            }];
        } else {
            [[db documentWithPath:collectionName] setData:notification.object completion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error writing document: %@", error);
                } else {
                    NSLog(@"Document successfully written");
                }
            }];
        }
    });
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL) method:(NSString*)method is:(NSString*)action {
    return [method isEqualToString:action];
}


@end
