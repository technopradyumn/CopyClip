package com.technopradyumn.copyclip

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull
import android.util.Log

class MainActivity: FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val WIDGET_HANDLER_CHANNEL = "com.technopradyumn.copyclip/widget_handler"
        private const val WIDGET_PIN_CHANNEL = "com.technopradyumn.copyclip/widget"
    }

    private var widgetHandlerChannel: MethodChannel? = null
    private var widgetPinChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup widget navigation channel
        widgetHandlerChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_HANDLER_CHANNEL)
        widgetHandlerChannel?.setMethodCallHandler { call, result ->
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

        // Setup widget pin channel
        widgetPinChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_PIN_CHANNEL)
        widgetPinChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPinWidget" -> {
                    val widgetType = call.argument<String>("widgetType")
                    if (widgetType != null) {
                        val success = requestPinWidget(widgetType)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "Widget type argument missing", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Request to pin a widget to the home screen (Android 8.0+)
     */
    private fun requestPinWidget(widgetType: String): Boolean {
        try {
            // Only available on Android O (API 26) and above
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                Log.w(TAG, "Widget pinning requires Android 8.0+")
                return false
            }

            val appWidgetManager = AppWidgetManager.getInstance(context)
            
            // Check if the launcher supports pinning widgets
            if (!appWidgetManager.isRequestPinAppWidgetSupported) {
                Log.w(TAG, "Launcher does not support widget pinning")
                return false
            }

            // Get the widget provider class name based on feature type
            val providerClassName = getWidgetProviderClassName(widgetType)
            if (providerClassName == null) {
                Log.e(TAG, "Unknown widget type: $widgetType")
                return false
            }

            val myProvider = ComponentName(context, providerClassName)
            
            // Create the PendingIntent object only if your app needs to be notified
            // when the user adds the widget.
            // This is optional - we can pass null if we don't need the callback
            val successCallback: android.app.PendingIntent? = null

            // Request to pin the widget
            val pinnedResult = appWidgetManager.requestPinAppWidget(myProvider, null, successCallback)
            
            Log.d(TAG, "Widget pin request result: $pinnedResult for type: $widgetType")
            return pinnedResult
            
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting widget pin: ${e.message}", e)
            return false
        }
    }

    /**
     * Map feature IDs to widget provider class names
     */
    private fun getWidgetProviderClassName(widgetType: String): String? {
        return when (widgetType) {
            "notes" -> "com.technopradyumn.copyclip.NotesWidgetProvider"
            "todos" -> "com.technopradyumn.copyclip.TodosWidgetProvider"
            "expenses" -> "com.technopradyumn.copyclip.ExpensesWidgetProvider"
            "journal" -> "com.technopradyumn.copyclip.JournalWidgetProvider"
            "clipboard" -> "com.technopradyumn.copyclip.ClipboardWidgetProvider"
            "calendar" -> "com.technopradyumn.copyclip.CalendarWidgetProvider"
            "canvas" -> "com.technopradyumn.copyclip.CanvasWidgetProvider"
            else -> null
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
                    val host = uri.host
                    val path = uri.path
                    Log.d(TAG, "Host: $host, Path: $path")

                    var route = ""

                    // NEW LOGIC: Handle 'app' host (Standardized Routes)
                    if (host == "app") {
                        // Special Case: Todo Toggle
                        if (path?.contains("/todos") == true) {
                            val action = intent.getStringExtra("todo_action")
                            val id = intent.getStringExtra("todo_id")
                            if (action == "toggle" && id != null) {
                                Log.d(TAG, "Toggling Todo: $id")
                                android.os.Handler(mainLooper).postDelayed({
                                    widgetHandlerChannel?.invokeMethod("toggleTodo", mapOf("id" to id))
                                }, 100)
                                return // Exit execution, don't navigate
                            }
                        }
                        
                        // For normal navigation (e.g. /notes/edit), we LIMIT manual navigation.
                        // Flutter's GoRouter (via Android Intent) handles this natively because of the Manifest Intent Filter.
                        // If we send it manually here, we get double navigation.
                        Log.d(TAG, "Ignoring manual 'navigateTo' for app host - relying on Flutter native deep linking")
                        return

                    } else {
                        // LEGACY LOGIC: Feature ID is host (copyclip://notes/edit)
                        // Should not be hit if we updated all widgets, but kept for safety
                        val featureId = host
                        route = getRouteForFeature(featureId)
                        
                        // ... (Existing legacy path handling logic omitted for brevity, logic simplified to prefer 'app' host) ...
                        if (path == "/edit") {
                             route = "$route/edit"
                             // Legacy ID extraction from intent extras would go here if needed
                             // But we are moving to query params.
                        }
                    }

                    Log.d(TAG, "Navigating to: $route")

                    // Send navigation command to Flutter
                    android.os.Handler(mainLooper).postDelayed({
                        widgetHandlerChannel?.invokeMethod("navigateTo", mapOf("route" to route))
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
        widgetHandlerChannel?.setMethodCallHandler(null)
        widgetHandlerChannel = null
        widgetPinChannel?.setMethodCallHandler(null)
        widgetPinChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}