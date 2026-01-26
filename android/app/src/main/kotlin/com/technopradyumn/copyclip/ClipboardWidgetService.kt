package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class ClipboardWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return ClipboardRemoteViewsFactory(this.applicationContext)
    }
}

class ClipboardRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var clipsArray = JSONArray()

    override fun onCreate() {
    }

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("clipboard_data", "[]")
            clipsArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            clipsArray = JSONArray()
        }
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return clipsArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.clipboard_widget_item)
        try {
            val clipObj = clipsArray.getJSONObject(position)
            val content = clipObj.optString("content", "Clip")
            
            views.setTextViewText(R.id.clipboard_item_content, content)
            
            val fillInIntent = Intent()
            fillInIntent.putExtra("clip_id", clipObj.optString("id"))
            fillInIntent.data = android.net.Uri.parse("copyclip://app/clipboard/edit?id=${clipObj.optString("id")}")
            views.setOnClickFillInIntent(R.id.clipboard_item_root, fillInIntent)
            
        } catch (e: Exception) {
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
