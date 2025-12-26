package com.technopradyumn.copyclip

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {

    // We only need the channel for widget navigation now
    private var widgetChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // --- HANDLER FOR WIDGET NAVIGATION ---
        // This is kept to allow your home screen widgets to trigger app navigation
        val widgetChannelName = "com.technopradyumn.copyclip/widget_handler"
        widgetChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannelName)

        widgetChannel?.setMethodCallHandler { call, result ->
            if (call.method == "navigateTo") {
                val route = call.argument<String>("route")
                if (route != null) {
                    // Send the route back to Dart side to handle navigation
                    // Since we removed eventChannel, we invoke the method directly on this channel
                    widgetChannel?.invokeMethod("navigateTo", route)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGUMENT", "Route argument missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        widgetChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}