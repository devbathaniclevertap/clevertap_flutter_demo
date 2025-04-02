package com.clevertap.demo

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.appcompat.app.AppCompatActivity  // ✅ Ensure correct activity type

import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/method_channel"

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(this)
            intent.extras?.let {
                cleverTapDefaultInstance?.pushNotificationClickedEvent(it)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showCoachMarks" -> {
                    val jsonString = call.arguments as? String
                    if (jsonString != null) {
                        showCoachMarks(jsonString) { response ->
                            result.success(response) // ✅ Send response back to Flutter
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Expected a JSON string", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    private fun getAppCompatActivity(): AppCompatActivity? {
        var context = this as? AppCompatActivity
        if (context != null) return context

        var currentContext = this.baseContext
        while (currentContext is android.content.ContextWrapper) {
            if (currentContext is AppCompatActivity) {
                return currentContext
            }
            currentContext = currentContext.baseContext
        }
        return null
    }

    private fun showCoachMarks(jsonString: String, onComplete: (String) -> Unit) {
        Log.d("Display data", jsonString)
        Handler(Looper.getMainLooper()).post {
            val activity = getAppCompatActivity()
            try {
                val jsonArray = org.json.JSONArray(jsonString) // Parse as JSONArray
                if (jsonArray.length() == 0) {
                    onComplete("Error: JSON array is empty")
                    return@post
                }

                val jsonObject = jsonArray.getJSONObject(0) // Get first object from array
                val coachMarkHelper = CoachMarkHelper()
                if (activity != null) {
                    coachMarkHelper.renderCoachMark(activity, jsonObject) {
                        onComplete("Coach mark completed")
                    }
                }
            } catch (e: Exception) {
                Log.e("CustomTemplatesModule", "Error rendering coach marks: ${e.message}")
                onComplete("Error: ${e.message}")
            }
        }
    }

}
