package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class CalendarWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return CalendarRemoteViewsFactory(this.applicationContext)
    }
}

class CalendarRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var eventsArray = JSONArray()

    override fun onCreate() {
        // Initial load could go here
    }

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("calendar_data", "[]")
            eventsArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            eventsArray = JSONArray()
        }
    }

    override fun onDestroy() {
        // No-op
    }

    override fun getCount(): Int {
        return eventsArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.calendar_widget_item)
        try {
            val eventObj = eventsArray.getJSONObject(position)
            val title = eventObj.optString("title", "Untitled")
            val time = eventObj.optString("time", "All Day")
            
            views.setTextViewText(R.id.calendar_item_title, title)
            views.setTextViewText(R.id.calendar_item_time, time)
            
            // Fill intent for click (optional, if we want specific item clicks to open details)
            // For now, let's just use the template to open calendar
            val fillInIntent = Intent()
            // We can add extras here if needed
            views.setOnClickFillInIntent(R.id.calendar_item_root, fillInIntent)
            
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
