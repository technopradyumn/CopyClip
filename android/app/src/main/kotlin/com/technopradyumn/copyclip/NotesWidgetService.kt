package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class NotesWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return NotesRemoteViewsFactory(this.applicationContext)
    }
}

class NotesRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var notesArray = JSONArray()

    override fun onCreate() {
        // Initial load could go here
    }

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("notes_data", "[]") ?: "[]"
            notesArray = if (jsonStr.isBlank() || jsonStr == "null") JSONArray() else JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            notesArray = JSONArray()
        }
    }

    override fun onDestroy() {
        // No-op
    }

    override fun getCount(): Int {
        return notesArray.length()
    }

        override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.note_widget_item)
        try {
            val noteObj = notesArray.getJSONObject(position)
            val title = noteObj.optString("title", "Untitled")
            val content = noteObj.optString("content", "")
            val date = noteObj.optString("date", "")
            val id = noteObj.optString("id")
            val colorValue = if (noteObj.has("color") && !noteObj.isNull("color")) noteObj.optLong("color") else null

            views.setTextViewText(R.id.note_item_title, title)
            views.setTextViewText(R.id.note_item_date, date)

            if (content.isNotEmpty() && content != title) {
                views.setTextViewText(R.id.note_item_content, content)
                views.setViewVisibility(R.id.note_item_content, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.note_item_content, android.view.View.GONE)
            }

            if (colorValue != null) {
                try {
                    val colorInt = colorValue.toInt() or 0xFF000000.toInt()
                    views.setInt(R.id.note_item_accent, "setBackgroundColor", colorInt)
                } catch (_: Exception) {}
            }

            // Fill intent for full card click -> Opens NoteEditScreen
            val fillInIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_OPEN_ITEM
                putExtra("note_id", id)
                data = android.net.Uri.parse("copyclip://app/notes/edit?id=$id")
            }
            views.setOnClickFillInIntent(R.id.note_item_root, fillInIntent)

            // Copy button click -> Copies note content/title (does NOT open app)
            val textToCopy = if (content.isNotEmpty()) content else title
            val copyIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_COPY_TEXT
                putExtra(WidgetActionReceiver.EXTRA_COPY_TEXT, textToCopy)
                putExtra(WidgetActionReceiver.EXTRA_COPY_LABEL, "Note: $title")
            }
            views.setOnClickFillInIntent(R.id.note_item_copy, copyIntent)

        } catch (e: Exception) {
            e.printStackTrace()
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? {
        return null // Use default
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
