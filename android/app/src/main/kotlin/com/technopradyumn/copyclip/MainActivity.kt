package com.technopradyumn.copyclip

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import android.text.TextUtils
import android.content.Context
import androidx.annotation.NonNull
import java.io.File

class MainActivity: FlutterActivity() {
    companion object {
        var eventChannel: MethodChannel? = null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channelName = "com.technopradyumn.copyclip/accessibility"
        eventChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        eventChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "openAccessibilitySettings" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(true)
                }
                "isServiceEnabled" -> {
                    result.success(isAccessibilityServiceEnabled(this))
                }
                "getPendingClips" -> {
                    val clips = readAndClearClipQueue()
                    result.success(clips)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun readAndClearClipQueue(): ArrayList<String> {
        val clipsList = ArrayList<String>()
        val queueDir = File(filesDir, "pending_clips")

        if (queueDir.exists() && queueDir.isDirectory) {
            val clipFiles = queueDir.listFiles()
            clipFiles?.sortBy { it.lastModified() } // Process clips in chronological order

            clipFiles?.forEach { file ->
                try {
                    val content = file.readText()
                    if (content.isNotEmpty()) {
                        clipsList.add(content)
                    }
                    file.delete() // Delete the file after reading
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        return clipsList
    }

    private fun isAccessibilityServiceEnabled(context: Context): Boolean {
        val expectedServiceName = "${context.packageName}/${ClipboardAccessibilityService::class.java.canonicalName}"
        val enabledServices = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        )

        if (enabledServices == null) return false
        val colonSplitter = TextUtils.SimpleStringSplitter(':')
        colonSplitter.setString(enabledServices)

        while (colonSplitter.hasNext()) {
            if (colonSplitter.next().equals(expectedServiceName, ignoreCase = true)) return true
        }
        return false
    }

    override fun cleanUpFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        eventChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}