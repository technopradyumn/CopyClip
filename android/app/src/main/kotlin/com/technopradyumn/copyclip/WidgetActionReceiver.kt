package com.technopradyumn.copyclip

import android.app.ActivityOptions
import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ClipData
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class WidgetActionReceiver : BroadcastReceiver() {

    companion object {
        const val ACTION_TOGGLE_TODO = "com.technopradyumn.copyclip.ACTION_TOGGLE_TODO"
        const val ACTION_COPY_TEXT = "com.technopradyumn.copyclip.ACTION_COPY_TEXT"
        const val ACTION_OPEN_ITEM = "com.technopradyumn.copyclip.ACTION_OPEN_ITEM"
        const val EXTRA_TODO_ID = "extra_todo_id"
        const val EXTRA_COPY_TEXT = "extra_copy_text"
        const val EXTRA_COPY_LABEL = "extra_copy_label"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        when (action) {
            ACTION_TOGGLE_TODO -> {
                val todoId = intent.getStringExtra(EXTRA_TODO_ID) ?: return
                handleToggleTodo(context, todoId)
            }
            ACTION_COPY_TEXT -> {
                val textToCopy = intent.getStringExtra(EXTRA_COPY_TEXT) ?: return
                val label = intent.getStringExtra(EXTRA_COPY_LABEL) ?: "Copied Text"
                handleCopyText(context, textToCopy, label)
            }
            ACTION_OPEN_ITEM -> {
                handleOpenItem(context, intent)
            }
            else -> {
                if (intent.data != null || intent.hasExtra("todo_id") || intent.hasExtra("note_id") || intent.hasExtra("clip_id")) {
                    handleOpenItem(context, intent)
                }
            }
        }
    }

    private fun handleToggleTodo(context: Context, todoId: String) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("todos_data", "[]") ?: "[]"
            val todosArray = JSONArray(jsonStr)

            var toggledDoneStatus: Boolean? = null
            val total = todosArray.length()
            var completedCount = 0

            for (i in 0 until todosArray.length()) {
                val item = todosArray.getJSONObject(i)
                val id = item.optString("id", "")
                if (id == todoId) {
                    val currentDone = item.optBoolean("isDone", false)
                    val newDone = !currentDone
                    item.put("isDone", newDone)
                    toggledDoneStatus = newDone
                }
                if (item.optBoolean("isDone", false)) {
                    completedCount++
                }
            }

            if (toggledDoneStatus != null) {
                // Save pending toggle for Flutter Hive synchronization
                val pendingJsonStr = widgetData.getString("pending_todo_toggles", "[]") ?: "[]"
                val pendingArray = try { JSONArray(pendingJsonStr) } catch (_: Exception) { JSONArray() }
                val newPendingObj = JSONObject()
                newPendingObj.put("id", todoId)
                newPendingObj.put("isDone", toggledDoneStatus)
                pendingArray.put(newPendingObj)

                // Update SharedPreferences with modified todos_data & todos_progress
                widgetData.edit()
                    .putString("todos_data", todosArray.toString())
                    .putString("todos_progress", "$completedCount/$total Done")
                    .putString("pending_todo_toggles", pendingArray.toString())
                    .apply()

                // Notify Flutter app if active
                MainActivity.instance?.notifyTodoToggled(todoId)

                // Notify AppWidgetManager of dataset change
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, TodosWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

                // Refresh the widget provider views
                val updateIntent = Intent(context, TodosWidgetProvider::class.java).apply {
                    this.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
                }
                context.sendBroadcast(updateIntent)

                // Notify list data change
                appWidgetIds.forEach { widgetId ->
                    appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.todos_list)
                }

                showToast(context, if (toggledDoneStatus) "Task completed! 🎉" else "Task marked incomplete")
            }
        } catch (e: Exception) {
            android.util.Log.e("WidgetActionReceiver", "Error toggling todo", e)
        }
    }

    private fun handleCopyText(context: Context, text: String, label: String) {
        try {
            val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val clip = ClipData.newPlainText(label, text)
            clipboard.setPrimaryClip(clip)

            showToast(context, "Copied to clipboard!")
        } catch (e: Exception) {
            android.util.Log.e("WidgetActionReceiver", "Error copying text", e)
        }
    }

    private fun handleOpenItem(context: Context, intent: Intent) {
        try {
            val launchIntent = Intent(context, MainActivity::class.java)
            launchIntent.action = Intent.ACTION_VIEW
            launchIntent.data = intent.data
            launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            intent.extras?.let { launchIntent.putExtras(it) }

            if (Build.VERSION.SDK_INT >= 34) {
                try {
                    val options = ActivityOptions.makeBasic()
                    val method = options.javaClass.getMethod("setPendingIntentBackgroundActivityStartMode", java.lang.Integer.TYPE)
                    method.invoke(options, 1)
                    context.startActivity(launchIntent, options.toBundle())
                    return
                } catch (_: Exception) {}
            }
            context.startActivity(launchIntent)
        } catch (e: Exception) {
            android.util.Log.e("WidgetActionReceiver", "Error opening item", e)
        }
    }

    private fun showToast(context: Context, message: String) {
        Handler(Looper.getMainLooper()).post {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
        }
    }
}
