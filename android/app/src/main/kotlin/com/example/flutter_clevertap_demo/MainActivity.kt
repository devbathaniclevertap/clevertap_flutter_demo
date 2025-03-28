package com.clevertap.demo

import android.content.Intent
import android.os.Build
import com.clevertap.android.sdk.CleverTapAPI
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // On Android 12 and above, inform the notification click to get the pushClickedPayloadReceived callback on dart side.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(this)
            intent.extras?.let {
                cleverTapDefaultInstance?.pushNotificationClickedEvent(it)
            }
        }
    }
}
