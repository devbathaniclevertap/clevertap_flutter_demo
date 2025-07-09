package com.example.flutter_clevertap_demo
import android.R
import android.os.Bundle
import android.util.Log
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.pushnotification.fcm.CTFcmMessageHandler
import com.clevertap.ct_templates.TemplateRenderer
import com.clevertap.ct_templates.pn.PushNotificationListener
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage


class MyFcmMessageListenerService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        message.data.apply {
            try {
                if (size > 0) {
                    val extras = Bundle()
                    for ((key, value) in this) {
                        extras.putString(key, value)
                    }
                    val info = CleverTapAPI.getNotificationInfo(extras)
                    if (info.fromCleverTap) {
                        if (extras.getString("pt_type").equals("custom")) {
                            TemplateRenderer.getInstance().showPushNotification(
                                applicationContext,
                                extras,
                                object : PushNotificationListener {
                                    override fun onPushRendered() {
                                        CleverTapAPI.getDefaultInstance(applicationContext)!!
                                            .pushNotificationViewedEvent(extras) // to track push impression.
                                    }

                                    override fun onPushFailed() {
                                        CTFcmMessageHandler().createNotification(
                                            applicationContext,
                                            message
                                        )
                                    }
                                })
                        } else {
                            CTFcmMessageHandler()
                                .createNotification(applicationContext, message)
                        }
                    }
                }
            } catch (t: Throwable) {
                Log.d("MYFCMLIST", "Error parsing FCM message", t)
            }
        }
    }


}