package com.transistorsoft.flutter.backgroundgeolocation;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import com.transistorsoft.tsfirebaseproxy.TSFirebaseProxy;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** BackgroundFetchPlugin */
public class BackgroundGeolocationFirebasePlugin implements MethodCallHandler {
    public static final String TAG                          = "TSFirebaseProxy";
    static final String PLUGIN_ID                           = "com.transistorsoft/flutter_background_geolocation_firebase";

    private static final String METHOD_CHANNEL_NAME         = PLUGIN_ID + "/methods";

    private Context mContext;
    private boolean isRegistered;

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
        channel.setMethodCallHandler(new BackgroundGeolocationFirebasePlugin(registrar));
    }

    private BackgroundGeolocationFirebasePlugin(Registrar registrar) {
        isRegistered = false;
        mContext = registrar.context().getApplicationContext();

        if (registrar.activity() != null) {
            Intent intent = registrar.activity().getIntent();
            String action = intent.getAction();

        }
    }

    @SuppressWarnings("unchecked")
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("configure")) {
            Map<String, Object> params = (Map<String, Object>) call.arguments;
            configure(params, result);
        } else {
            result.notImplemented();
        }
    }

    private void configure(Map<String, Object> params, Result result) {
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
