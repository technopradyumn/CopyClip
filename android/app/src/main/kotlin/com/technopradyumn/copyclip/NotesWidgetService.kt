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
            val jsonStr = widgetData.getString("notes_data", "[]")
            notesArray = JSONArray(jsonStr)
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
            val date = noteObj.optString("date", "")
            
            views.setTextViewText(R.id.note_item_title, title)
            views.setTextViewText(R.id.note_item_date, date)
            
            // Fill intent for click
            val fillInIntent = Intent()
            fillInIntent.putExtra("note_id", noteObj.optString("id"))
            views.setOnClickFillInIntent(R.id.note_item_title, fillInIntent) // Bind to title or parent
            
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
