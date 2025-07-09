package com.example.flutter_clevertap_demo

import android.Manifest
import android.app.AlertDialog
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.clevertap.android.geofence.CTGeofenceAPI
import com.clevertap.android.geofence.CTGeofenceSettings
import com.clevertap.android.geofence.interfaces.CTGeofenceEventsListener
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.CleverTapAPI.getDefaultInstance
import com.clevertap.android.sdk.inapp.customtemplates.template
import com.clevertap.clevertap_plugin.ClevertapCustomTemplates
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import com.google.firebase.analytics.FirebaseAnalytics
import dev.flutter.example.NativeViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject


class MainActivity : FlutterActivity() {
    private val LOCATION_PERMISSION_REQUEST = 1001
    private val CHANNEL = "com.example.yourapp/method_channel"
    private val CHANNELS = "custom_channel/notification"
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
        val defaultInstance = CleverTapAPI.getDefaultInstance(this)
        defaultInstance?.let { ins ->
            Log.i("FIREBASE LOG", "setting object id to firebase : ${ins.cleverTapID}")
            FirebaseAnalytics.getInstance(this).setUserProperty("ct_objectId", ins.cleverTapID)
        } ?: run {
            Log.e("FIREBASE LOG", "Uninstall tracking not setup cause of non initialised instance")
        }

        Log.d("Android","In the MainApplication")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNELS).setMethodCallHandler {
                call, result ->
            if (call.method == "cancelNotification") {
                val notificationId = call.argument<Int>("notificationId") ?: -1
                if (notificationId > -1) {
                    val notifyMgr = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    notifyMgr.cancel(notificationId)
                    result.success(null)
                } else {
                    result.error("INVALID_ID", "Notification ID is invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }
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

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        var cleverTapDefaultInstance: CleverTapAPI? = null
        cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(applicationContext)
        // On Android 12 and above, inform the notification click to get the pushClickedPayloadReceived callback on dart side.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            cleverTapDefaultInstance?.pushNotificationClickedEvent(intent.extras)
        }
    }

    private fun requestLocationPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val fineLocation = checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
            val coarseLocation = checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION)
            
            val permissionsToRequest = mutableListOf<String>()
            
            if (fineLocation != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }
            if (coarseLocation != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(Manifest.permission.ACCESS_COARSE_LOCATION)
            }

            if (permissionsToRequest.isNotEmpty()) {
                requestPermissions(
                    permissionsToRequest.toTypedArray(),
                    LOCATION_PERMISSION_REQUEST
                )
            } else {
                // Location permissions are already granted, request background location if needed
                requestBackgroundLocation()
            }
        }
    }

    private fun requestBackgroundLocation() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val backgroundLocation = checkSelfPermission(Manifest.permission.ACCESS_BACKGROUND_LOCATION)
            
            if (backgroundLocation != PackageManager.PERMISSION_GRANTED) {
                AlertDialog.Builder(this)
                    .setTitle("Background Location Permission")
                    .setMessage("This app needs background location access to notify you about nearby offers. Please allow background location access.")
                    .setPositiveButton("Allow") { _, _ ->
                        requestPermissions(
                            arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                            LOCATION_PERMISSION_REQUEST + 1
                        )
                    }
                    .setNegativeButton("Deny") { dialog, _ ->
                        dialog.dismiss()
                    }
                    .create()
                    .show()
            } else {
                initializeGeofencing()
            }
        } else {
            initializeGeofencing()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        when (requestCode) {
            LOCATION_PERMISSION_REQUEST -> {
                if (grantResults.isNotEmpty() && 
                    grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                    // Location permissions granted, request background location
                    requestBackgroundLocation()
                }
            }
            LOCATION_PERMISSION_REQUEST + 1 -> {
                if (grantResults.isNotEmpty() && 
                    grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Background location permission granted
                    initializeGeofencing()
                }
            }
        }
    }

    private fun initializeGeofencing() {
        Log.d("MainActivity", "Initializing geofencing")
        val cleverTapAPI = CleverTapAPI.getDefaultInstance(applicationContext)
        if (cleverTapAPI != null) {
            CTGeofenceAPI.getInstance(applicationContext).init(ctGeofenceSettings, cleverTapAPI)
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
        } else {
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