package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import android.view.View
import org.json.JSONArray
import org.json.JSONObject

class TodosWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return TodosRemoteViewsFactory(this.applicationContext)
    }
}

class TodosRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var todosArray = JSONArray()

    override fun onCreate() {
    }

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("todos_data", "[]")
            todosArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            todosArray = JSONArray()
        }
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return todosArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.todo_widget_item)
        try {
            val todoObj = todosArray.getJSONObject(position)
            val todoItem = todoObj // Renamed from todoObj to todoItem as per the provided code
            val task = todoItem.getString("task")
            val isDone = todoItem.optBoolean("isDone", false)
            val category = todoItem.optString("category", "Personal")
            val hasReminder = todoItem.optBoolean("hasReminder", false)
            val todoId = todoItem.getString("id")

            views.setTextViewText(R.id.todo_item_task, task)
            views.setTextViewText(R.id.todo_item_category, category)

            // Reminder Icon
            if (hasReminder) {
                views.setViewVisibility(R.id.todo_item_reminder, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.todo_item_reminder, View.GONE)
            }

            // Checkbox & Color Logic
            if (isDone) {
                 views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_checkbox_checked_green)
                 views.setInt(R.id.todo_item_task, "setPaintFlags", 16) // Strike through
                 views.setTextColor(R.id.todo_item_task, android.graphics.Color.parseColor("#8E8E93")) // Grey
            } else {
                // Undone: Reset to Primary Color (Black/White)
                 val isNight = (context.resources.configuration.uiMode and android.content.res.Configuration.UI_MODE_NIGHT_MASK) == android.content.res.Configuration.UI_MODE_NIGHT_YES
                 val textColor = if (isNight) android.graphics.Color.WHITE else android.graphics.Color.BLACK
                 
                 views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_checkbox_unchecked_red)
                 views.setInt(R.id.todo_item_task, "setPaintFlags", 0) // Normal
                 views.setTextColor(R.id.todo_item_task, textColor) 
            }

            // 1. Click on Row -> Open Edit Screen
            val editIntent = Intent()
            editIntent.putExtra("todo_id", todoId)
            editIntent.data = android.net.Uri.parse("copyclip://app/todos/edit?id=$todoId")
            views.setOnClickFillInIntent(R.id.todo_item_root, editIntent)

            // 2. Click on Checkbox -> Toggle Status
            val toggleIntent = Intent()
            toggleIntent.putExtra("todo_id", todoId)
            toggleIntent.putExtra("todo_action", "toggle")
            toggleIntent.data = android.net.Uri.parse("copyclip://app/todos/toggle") // Add explicit data
            views.setOnClickFillInIntent(R.id.todo_item_check, toggleIntent)
            
            return views       } catch (e: Exception) {
            e.printStackTrace()
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }
}
