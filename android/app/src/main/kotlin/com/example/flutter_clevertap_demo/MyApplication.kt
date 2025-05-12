package com.clevertap.demo

import com.clevertap.android.sdk.Application
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.CleverTapAPI.*
import com.clevertap.clevertap_plugin.CleverTapApplication
import com.clevertap.android.pushtemplates.PushTemplateNotificationHandler
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.signedcall.fcm.SignedCallNotificationHandler

class MyApplication: CleverTapApplication() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        val cleverTapAPI = getDefaultInstance(applicationContext)
        CleverTapAPI.setNotificationHandler(PushTemplateNotificationHandler());
        CleverTapAPI.setSignedCallNotificationHandler(SignedCallNotificationHandler());
        super.onCreate()
    }

}