package dev.flutter.example

import android.content.Context
import android.util.Log // <-- Import Log
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

object NativeViewRegistry {
    val viewMap: MutableMap<String, Int> = mutableMapOf()

    fun registerView(tag: String, viewId: Int) {
        viewMap[tag] = viewId
    }

    fun getViewId(tag: String): Int {
        return viewMap[tag] ?: 0
    }
}

internal class NativeView(context: Context, id: Int, creationParams: Map<String, Any>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        val viewTag = creationParams?.get("tag") as? String ?: "default_tag_error"
        textView = TextView(context)
        textView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        textView.textSize = 1f
        textView.alpha = 0.01f // Almost invisible but still present
        textView.text = ""
        textView.id = id
        textView.contentDescription = viewTag
        textView.tag = viewTag
        NativeViewRegistry.registerView(viewTag, textView.id)
        Log.i("NativeView", ">>> NativeView CREATED - ID: ${textView.id}, ContentDescription: '$viewTag'")
    }
}