package com.clevertap.demo

import android.content.Context
import android.content.res.Resources
import android.view.View
import android.view.Window
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleRegistry
import io.flutter.embedding.android.FlutterActivity

class FlutterAppCompatDelegate(
    private val activity: FlutterActivity
) : AppCompatActivity() {
    
    private val _lifecycleRegistry = LifecycleRegistry(this)

    init {
        _lifecycleRegistry.currentState = Lifecycle.State.CREATED
    }
    
    override fun getWindow(): Window = activity.window
    
    override fun <T : View> findViewById(id: Int): T? = activity.findViewById(id)
    
    override fun getBaseContext(): Context = activity
    
    override fun getResources(): Resources = activity.resources
    
    override fun getApplicationContext(): Context = activity.applicationContext
    
    // Make this delegate accessible as an AppCompatActivity
    fun asAppCompatActivity(): AppCompatActivity = this
}