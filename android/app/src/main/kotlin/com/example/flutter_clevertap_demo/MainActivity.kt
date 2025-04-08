package com.example.flutter_clevertap_demo

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import dev.flutter.example.NativeViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/method_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "tagged_view",
                NativeViewFactory()
            )

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

    private fun showCoachMarks(jsonString: String) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                val jsonArray = JSONArray(jsonString)
                if (jsonArray.length() > 0) {
                    val jsonObject = jsonArray.getJSONObject(0)
                    val coachMarkHelper = CoachMarkHelper()
                    
                    // Since we're now extending FlutterActivity (which is an AppCompatActivity)
                    coachMarkHelper.renderCoachMark(this, jsonObject) {
                        Log.d("MainActivity", "Coach marks completed")
                    }
                }
            } catch (e: Exception) {
                Log.e("MainActivity", "Error showing coach marks: ${e.message}")
                e.printStackTrace()
            }
        }, 1000)
    }
}