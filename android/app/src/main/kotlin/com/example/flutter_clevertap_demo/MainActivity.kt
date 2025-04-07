package com.example.flutter_clevertap_demo

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleRegistry
import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper
import dev.flutter.example.NativeViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import androidx.lifecycle.LifecycleOwner
import android.view.ViewGroup

class MainActivity : FlutterActivity() {
    private lateinit var appCompatDelegate: FlutterAppCompatDelegate
    private lateinit var lifecycleRegistry: LifecycleRegistry
    private val CHANNEL = "com.example.yourapp/method_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lifecycleRegistry = LifecycleRegistry(this)
        appCompatDelegate = FlutterAppCompatDelegate(this)
        lifecycleRegistry.currentState = Lifecycle.State.CREATED
        lifecycleRegistry.currentState = Lifecycle.State.STARTED
        lifecycleRegistry.currentState = Lifecycle.State.RESUMED
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register the platform view factory
        // Register the platform view factory
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "tagged_view",
                NativeViewFactory()
            )

        // Setup method channel
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
                    
                    // Get the Flutter activity window token
                    val token = window?.decorView?.windowToken
                    if (token != null) {
                        runOnUiThread {
                            coachMarkHelper.renderCoachMark(this@MainActivity, jsonObject) {
                                Log.d("MainActivity", "Coach marks completed")
                            }
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e("MainActivity", "Error showing coach marks: ${e.message}")
                e.printStackTrace()
            }
        }, 1000)
    }

    override fun onDestroy() {
        super.onDestroy()
        // Update lifecycle state
        lifecycleRegistry.currentState = Lifecycle.State.DESTROYED
    }
}