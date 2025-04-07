package dev.flutter.example

import android.content.Context
import android.util.Log // <-- Import Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        // *** ADD THIS LOG ***
        // This tells you if Flutter is asking this factory to create a view.
        Log.i("NativeViewFactory", ">>> CREATE called - viewId: $viewId, args: $args")

        val creationParams: Map<String, Any>? = args as? Map<String, Any>
        return NativeView(context, viewId, creationParams)
    }
}