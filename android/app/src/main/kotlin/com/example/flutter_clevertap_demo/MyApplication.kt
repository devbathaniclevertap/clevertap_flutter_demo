package com.example.flutter_clevertap_demo

import com.clevertap.android.sdk.Application
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.CleverTapAPI.*
import com.clevertap.clevertap_plugin.CleverTapApplication
import com.clevertap.android.pushtemplates.PushTemplateNotificationHandler
import com.clevertap.android.sdk.ActivityLifecycleCallback

class MyApplication: CleverTapApplication() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        val cleverTapAPI = getDefaultInstance(applicationContext)
        CleverTapAPI.setNotificationHandler(PushTemplateNotificationHandler());
        super.onCreate()
    }

}