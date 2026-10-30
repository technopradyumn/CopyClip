package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import android.view.View
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

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
            val jsonStr = widgetData.getString("todos_data", "[]") ?: "[]"
            todosArray = if (jsonStr.isBlank() || jsonStr == "null") JSONArray() else JSONArray(jsonStr)
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
            val todoItem = todosArray.getJSONObject(position)
            val task = todoItem.optString("task", "Untitled Task")
            val isDone = todoItem.optBoolean("isDone", false)
            val category = todoItem.optString("category", "")
            val hasReminder = todoItem.optBoolean("hasReminder", false)
            val todoId = todoItem.optString("id", position.toString())
            val dueDateStr = todoItem.optString("dueDate", "")
            val repeatInterval = todoItem.optString("repeatInterval", "")

            // Parse due date
            var dueDate: Date? = null
            if (dueDateStr.isNotEmpty() && dueDateStr != "null") {
                try {
                    val isoFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
                    // Handle ISO format with optional parts
                    val cleanStr = dueDateStr.replace("Z", "").split(".")[0]
                    dueDate = isoFormat.parse(cleanStr)
                } catch (e: Exception) {
                    // Try alternative format
                    try {
                        val altFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
                        dueDate = altFormat.parse(dueDateStr)
                    } catch (_: Exception) {}
                }
            }

            // Determine task state
            val isOverdue = dueDate != null && !isDone && isBeforeToday(dueDate)
            val isDueToday = dueDate != null && !isDone && isSameDay(dueDate, Date())
            val isFuture = dueDate != null && !isDone && !isOverdue && !isDueToday

            val isNight = (context.resources.configuration.uiMode and
                    android.content.res.Configuration.UI_MODE_NIGHT_MASK) ==
                    android.content.res.Configuration.UI_MODE_NIGHT_YES

            // --- Task Text ---
            views.setTextViewText(R.id.todo_item_task, task)

            // --- Category ---
            if (category.isNotEmpty() && category != "null") {
                views.setTextViewText(R.id.todo_item_category, category)
                views.setViewVisibility(R.id.todo_item_category, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.todo_item_category, View.GONE)
            }

            // --- Card Background (color-coded by state) ---
            when {
                isDone -> {
                    views.setInt(R.id.todo_item_root, "setBackgroundResource", R.drawable.todo_card_done)
                }
                isOverdue -> {
                    views.setInt(R.id.todo_item_root, "setBackgroundResource", R.drawable.todo_card_overdue)
                }
                isDueToday -> {
                    views.setInt(R.id.todo_item_root, "setBackgroundResource", R.drawable.todo_card_today)
                }
                isFuture -> {
                    views.setInt(R.id.todo_item_root, "setBackgroundResource", R.drawable.todo_card_future)
                }
                else -> {
                    views.setInt(R.id.todo_item_root, "setBackgroundResource", R.drawable.todo_card_default)
                }
            }

            // --- Checkbox (circular, color-coded) ---
            when {
                isDone -> {
                    views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_circle_check_done)
                    // Strikethrough + grey text
                    views.setInt(R.id.todo_item_task, "setPaintFlags", 16) // STRIKE_THRU_TEXT_FLAG
                    views.setTextColor(R.id.todo_item_task, android.graphics.Color.parseColor("#8E8E93"))
                    views.setTextColor(R.id.todo_item_category, android.graphics.Color.parseColor("#AEAEB2"))
                }
                isOverdue -> {
                    views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_circle_unchecked_red)
                    views.setInt(R.id.todo_item_task, "setPaintFlags", 0)
                    val textColor = android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    views.setTextColor(R.id.todo_item_task, textColor)
                    views.setTextColor(R.id.todo_item_category, android.graphics.Color.parseColor("#8E8E93"))
                }
                isDueToday -> {
                    // Use red color instead of orange color for undone task
                    views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_circle_unchecked_red)
                    views.setInt(R.id.todo_item_task, "setPaintFlags", 0)
                    val textColor = android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    views.setTextColor(R.id.todo_item_task, textColor)
                    views.setTextColor(R.id.todo_item_category, android.graphics.Color.parseColor("#8E8E93"))
                }
                isFuture -> {
                    views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_circle_unchecked_blue)
                    views.setInt(R.id.todo_item_task, "setPaintFlags", 0)
                    val textColor = android.graphics.Color.parseColor(if (isNight) "#64B5F6" else "#007AFF")
                    views.setTextColor(R.id.todo_item_task, textColor)
                    views.setTextColor(R.id.todo_item_category, android.graphics.Color.parseColor("#8E8E93"))
                }
                else -> {
                    // Normal (no due date)
                    views.setImageViewResource(R.id.todo_item_check, R.drawable.ic_circle_unchecked)
                    views.setInt(R.id.todo_item_task, "setPaintFlags", 0)
                    val textColor = if (isNight) android.graphics.Color.WHITE else android.graphics.Color.BLACK
                    views.setTextColor(R.id.todo_item_task, textColor)
                    views.setTextColor(R.id.todo_item_category, android.graphics.Color.parseColor("#8E8E93"))
                }
            }

            // --- Due Date Row ---
            if (dueDate != null) {
                views.setViewVisibility(R.id.todo_item_due_row, View.VISIBLE)

                // Format: "Oct 29 • 10:00 AM"
                val displayFormat = SimpleDateFormat("MMM d • h:mm a", Locale.getDefault())
                val formattedDate = displayFormat.format(dueDate)
                views.setTextViewText(R.id.todo_item_due_date, formattedDate)

                // Color the due date text and calendar icon based on state
                val dueDateColor = when {
                    isDone -> android.graphics.Color.parseColor("#8E8E93")
                    isOverdue -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isDueToday -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isFuture -> android.graphics.Color.parseColor(if (isNight) "#64B5F6" else "#007AFF")
                    else -> android.graphics.Color.parseColor("#8E8E93")
                }
                views.setTextColor(R.id.todo_item_due_date, dueDateColor)
                views.setInt(R.id.todo_item_calendar_icon, "setColorFilter", dueDateColor)
            } else {
                views.setViewVisibility(R.id.todo_item_due_row, View.GONE)
            }

            // --- Reminder Icon ---
            if (hasReminder && dueDate != null) {
                views.setViewVisibility(R.id.todo_item_reminder, View.VISIBLE)
                // Tint the bell to match due date color
                val reminderColor = when {
                    isDone -> android.graphics.Color.parseColor("#8E8E93")
                    isOverdue -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isDueToday -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isFuture -> android.graphics.Color.parseColor(if (isNight) "#64B5F6" else "#007AFF")
                    else -> android.graphics.Color.parseColor("#8E8E93")
                }
                views.setInt(R.id.todo_item_reminder, "setColorFilter", reminderColor)
            } else {
                views.setViewVisibility(R.id.todo_item_reminder, View.GONE)
            }

            // --- Repeat Interval ---
            if (repeatInterval.isNotEmpty() && repeatInterval != "null" && dueDate != null) {
                views.setViewVisibility(R.id.todo_item_repeat_icon, View.VISIBLE)
                views.setViewVisibility(R.id.todo_item_repeat_text, View.VISIBLE)
                val repeatColor = when {
                    isDone -> android.graphics.Color.parseColor("#8E8E93")
                    isOverdue -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isDueToday -> android.graphics.Color.parseColor(if (isNight) "#FF6961" else "#FF3B30")
                    isFuture -> android.graphics.Color.parseColor(if (isNight) "#64B5F6" else "#007AFF")
                    else -> android.graphics.Color.parseColor("#8E8E93")
                }
                views.setInt(R.id.todo_item_repeat_icon, "setColorFilter", repeatColor)
                val formattedRepeat = repeatInterval.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
                views.setTextViewText(R.id.todo_item_repeat_text, formattedRepeat)
                views.setTextColor(R.id.todo_item_repeat_text, repeatColor)
            } else {
                views.setViewVisibility(R.id.todo_item_repeat_icon, View.GONE)
                views.setViewVisibility(R.id.todo_item_repeat_text, View.GONE)
            }

            // --- Click Intents ---
            // Click on Row -> Open Edit Screen in App
            val editIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_OPEN_ITEM
                putExtra("todo_id", todoId)
                putExtra(WidgetActionReceiver.EXTRA_TODO_ID, todoId)
                data = android.net.Uri.parse("copyclip://app/todos/edit?id=$todoId")
            }
            views.setOnClickFillInIntent(R.id.todo_item_root, editIntent)

            // Click on Checkbox -> Toggle Done status (does NOT open app)
            val toggleIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_TOGGLE_TODO
                putExtra(WidgetActionReceiver.EXTRA_TODO_ID, todoId)
            }
            views.setOnClickFillInIntent(R.id.todo_item_check, toggleIntent)

        } catch (e: Exception) {
            e.printStackTrace()
        }
        return views
    }

    private fun isBeforeToday(date: Date): Boolean {
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        return date.before(cal.time)
    }

    private fun isSameDay(date1: Date, date2: Date): Boolean {
        val cal1 = Calendar.getInstance().apply { time = date1 }
        val cal2 = Calendar.getInstance().apply { time = date2 }
        return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
               cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR)
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
