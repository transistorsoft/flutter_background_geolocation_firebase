package com.transistorsoft.flutter.backgroundgeolocation;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.transistorsoft.tsfirebaseproxy.TSFirebaseProxy;

import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BackgroundGeolocationFirebaseModule implements MethodChannel.MethodCallHandler {

    private static BackgroundGeolocationFirebaseModule sInstance;

    static BackgroundGeolocationFirebaseModule getInstance() {
        if (sInstance == null) {
            sInstance = getInstanceSynchronized();
        }
        return sInstance;
    }

    private static synchronized BackgroundGeolocationFirebaseModule getInstanceSynchronized() {
        if (sInstance == null) sInstance = new BackgroundGeolocationFirebaseModule();
        return sInstance;
    }

    public static final String TAG                          = "TSFirebaseProxy";
    static final String PLUGIN_ID                           = "com.transistorsoft/flutter_background_geolocation_firebase";

    private static final String METHOD_CHANNEL_NAME         = PLUGIN_ID + "/methods";

    private Context mContext;
    private boolean isRegistered;
    private final AtomicBoolean mIsAttachedToEngine = new AtomicBoolean(false);
    private MethodChannel mMethodChannel;

    private BackgroundGeolocationFirebaseModule() {

    }

    void onAttachedToEngine(Context context, BinaryMessenger messenger) {
        mIsAttachedToEngine.set(true);
        mContext = context;

        mMethodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        mMethodChannel.setMethodCallHandler(this);
    }

    void onDetachedFromEngine() {
        mIsAttachedToEngine.set(false);
    }

    void setActivity(Activity activity) {
        if (activity != null) {
            // Doing nothing currently.
        }
        isRegistered = false;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("configure")) {
            Map<String, Object> params = (Map<String, Object>) call.arguments;
            configure(params, result);
        } else {
            result.notImplemented();
        }
    }

    private void configure(Map<String, Object> params, @NonNull MethodChannel.Result result) {
        TSFirebaseProxy proxy = TSFirebaseProxy.getInstance(mContext);
        if (params.containsKey("locationsCollection")) {
            proxy.setLocationsCollection((String) params.get("locationsCollection"));
        }
        if (params.containsKey("geofencesCollection")) {
            proxy.setGeofencesCollection((String) params.get("geofencesCollection"));
        }
        if (params.containsKey("updateSingleDocument")) {
            proxy.setUpdateSingleDocument((boolean) params.get("updateSingleDocument"));
        }

        proxy.save(mContext);
        if (!isRegistered) {
            isRegistered = true;
            proxy.register(mContext);
        }
        result.success(true);
    }
}
