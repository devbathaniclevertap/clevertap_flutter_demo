package com.example.flutter_clevertap_demo

import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.Application
import com.clevertap.clevertap_plugin.ClevertapCustomTemplates

class MainApplication : Application() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        ClevertapCustomTemplates.registerCustomTemplates(this, "templates.json")
        super.onCreate()
    }
}