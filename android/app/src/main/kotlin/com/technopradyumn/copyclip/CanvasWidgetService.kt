package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class CanvasWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return CanvasRemoteViewsFactory(this.applicationContext)
    }
}

class CanvasRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var canvasArray = JSONArray()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("canvas_data", "[]")
            canvasArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            canvasArray = JSONArray()
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return canvasArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.canvas_widget_item)
        try {
            val item = canvasArray.getJSONObject(position)
            val title = item.optString("title", "Untitled")
            val date = item.optString("date", "")
            val id = item.optString("id", "")

            views.setTextViewText(R.id.canvas_item_title, title)
            views.setTextViewText(R.id.canvas_item_date, date)

            val fillInIntent = Intent()
            fillInIntent.putExtra("canvas_id", id) // Keep for legacy safety
            fillInIntent.data = android.net.Uri.parse("copyclip://app/canvas/edit?id=$id")
            views.setOnClickFillInIntent(R.id.canvas_item_root, fillInIntent)
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
