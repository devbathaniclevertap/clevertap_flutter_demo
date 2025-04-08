package com.example.flutter_clevertap_demo

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.NonNull
import com.clevertap.android.geofence.CTGeofenceAPI
import com.clevertap.android.geofence.CTGeofenceSettings
import com.clevertap.android.geofence.interfaces.CTGeofenceEventsListener
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import dev.flutter.example.NativeViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/method_channel"
    var ctGeofenceSettings = CTGeofenceSettings.Builder()
        .enableBackgroundLocationUpdates(true)//boolean to enable background location updates
        .build()


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "tagged_view",
                NativeViewFactory()
            )
        enableGeoFence()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showCoachMarks" -> {
                        val jsonString = call.arguments as? String
                        if (jsonString != null) {
                            showCoachMarks(jsonString)
                            result.success("Coach mark processing initiated")
                        } else {
                            result.error("INVALID_ARGUMENT", "Expected a JSON string for coach marks", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
    private  fun enableGeoFence(){
        Log.d("MainActivity", "onCreate called")
        val cleverTapAPI = CleverTapAPI.getDefaultInstance(getApplicationContext())
        if (cleverTapAPI != null) {
            CTGeofenceAPI.getInstance(getApplicationContext()).init(ctGeofenceSettings, cleverTapAPI)
            CTGeofenceAPI.getInstance(applicationContext)
                .setCtGeofenceEventsListener(object : CTGeofenceEventsListener {
                    override fun onGeofenceEnteredEvent(jsonObject: JSONObject) {
                        Log.d("MainActivity", "Geofence entered")
                        cleverTapAPI.pushEvent("Office Reached")
                    }
                    override fun onGeofenceExitedEvent(jsonObject: JSONObject) {
                        Log.d("MainActivity", "Geofence exited")
                        cleverTapAPI.pushEvent("Office Exited")
                    }
                })

        }else{
            Log.e("MainActivity", "CleverTapAPI is null")
        }
    }
    private fun showCoachMarks(jsonString: String) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                val jsonArray = JSONArray(jsonString)
                if (jsonArray.length() > 0) {
                    val jsonObject = jsonArray.getJSONObject(0)
                    runOnUiThread {
                        val coachMarkHelper = CoachMarkHelper()
                        coachMarkHelper.renderCoachMark(this, jsonObject) {
                            Log.d("MainActivity", "Coach marks completed")
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e("MainActivity", "Error showing coach marks: ${e.message}")
                e.printStackTrace()
            }
        }, 1500) // Increased delay
    }
}