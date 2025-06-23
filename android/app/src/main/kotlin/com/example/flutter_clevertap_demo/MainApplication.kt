package com.example.flutter_clevertap_demo

import com.clevertap.android.pushtemplates.PushTemplateNotificationHandler
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.Application
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.interfaces.NotificationHandler
import com.clevertap.clevertap_plugin.ClevertapCustomTemplates


class MainApplication : Application() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        ClevertapCustomTemplates.registerCustomTemplates(this, "templates.json")
        CleverTapAPI.setNotificationHandler(PushTemplateNotificationHandler() as NotificationHandler);
        if (CleverTapAPI.getDefaultInstance(this) != null) {
            // Call Android interface to remove the Email property
            CleverTapAPI.getDefaultInstance(this)?.removeValueForKey("Email");
        }
        super.onCreate()
    }
}