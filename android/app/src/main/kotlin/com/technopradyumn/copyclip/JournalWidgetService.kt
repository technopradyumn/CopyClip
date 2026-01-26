package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class JournalWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return JournalRemoteViewsFactory(this.applicationContext)
    }
}

class JournalRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var journalArray = JSONArray()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("journal_data", "[]")
            journalArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            journalArray = JSONArray()
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return journalArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.journal_widget_item)
        try {
            val item = journalArray.getJSONObject(position)
            val title = item.optString("title", "Untitled")
            val date = item.optString("date", "")
            val id = item.optString("id", "")
            val mood = item.optString("mood", "📖")

            views.setTextViewText(R.id.journal_item_title, title)
            views.setTextViewText(R.id.journal_item_date, date)
            views.setTextViewText(R.id.journal_item_emoji, mood)

            val fillInIntent = Intent()
            fillInIntent.putExtra("journal_id", id) // Keep for legacy safety
            fillInIntent.data = android.net.Uri.parse("copyclip://app/journal/edit?id=$id")
            views.setOnClickFillInIntent(R.id.journal_item_root, fillInIntent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? { return null }
    override fun getViewTypeCount(): Int { return 1 }
    override fun getItemId(position: Int): Long { return position.toLong() }
    override fun hasStableIds(): Boolean { return true }
}
