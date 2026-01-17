package com.technopradyumn.copyclip

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull
import android.util.Log

class MainActivity: FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val WIDGET_CHANNEL = "com.technopradyumn.copyclip/widget_handler"
    }

    private var widgetChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup widget navigation channel
        widgetChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)

        widgetChannel?.setMethodCallHandler { call, result ->
            if (call.method == "navigateTo") {
                val route = call.argument<String>("route")
                if (route != null) {
                    Log.d(TAG, "Widget navigation requested: $route")
                    result.success(true)
                } else {
                    result.error("INVALID_ARGUMENT", "Route argument missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate called")
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent called")
        setIntent(intent)
        handleIntent(intent)
    }

    /**
     * Handle deep link intents from widgets
     */
    private fun handleIntent(intent: Intent?) {
        if (intent == null) {
            Log.d(TAG, "Intent is null")
            return
        }

        Log.d(TAG, "Handling intent: ${intent.action}")

        // Check if this is a deep link from widget
        if (intent.action == Intent.ACTION_VIEW) {
            val uri: Uri? = intent.data

            if (uri != null) {
                Log.d(TAG, "Deep link URI: $uri")

                // Check if it's our copyclip:// scheme
                if (uri.scheme == "copyclip") {
                    val featureId = uri.host
                    Log.d(TAG, "Feature ID from URI: $featureId")

                    val route = getRouteForFeature(featureId)
                    Log.d(TAG, "Navigating to route: $route")

                    // Send navigation command to Flutter
                    // Wait a bit to ensure Flutter engine is ready
                    android.os.Handler(mainLooper).postDelayed({
                        widgetChannel?.invokeMethod("navigateTo", mapOf("route" to route))
                    }, 100)
                }
            } else {
                Log.d(TAG, "URI is null")
            }
        }
    }

    /**
     * Map feature IDs to Flutter routes
     */
    private fun getRouteForFeature(featureId: String?): String {
        return when (featureId) {
            "notes" -> "/notes"
            "todos" -> "/todos"
            "expenses" -> "/expenses"
            "journal" -> "/journal"
            "calendar" -> "/calendar"
            "clipboard" -> "/clipboard"
            "canvas" -> "/canvas"
            else -> {
                Log.w(TAG, "Unknown feature ID: $featureId, defaulting to dashboard")
                "/dashboard"
            }
        }
    }

    override fun cleanUpFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.d(TAG, "Cleaning up Flutter engine")
        widgetChannel?.setMethodCallHandler(null)
        widgetChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}