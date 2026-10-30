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
            val jsonStr = widgetData.getString("clipboard_data", "[]") ?: "[]"
            clipsArray = if (jsonStr.isBlank() || jsonStr == "null") JSONArray() else JSONArray(jsonStr)
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
            val type = clipObj.optString("type", "TEXT").uppercase()
            val date = clipObj.optString("date", "")
            val id = clipObj.optString("id", position.toString())

            val widgetData = HomeWidgetPlugin.getData(context)
            val primaryColorInt = when (val colorRaw = widgetData.all["primary_color"]) {
                is Number -> colorRaw.toInt()
                is String -> colorRaw.toIntOrNull() ?: android.graphics.Color.parseColor("#6366F1")
                else -> android.graphics.Color.parseColor("#6366F1")
            }

            views.setTextViewText(R.id.clipboard_item_content, content)
            views.setTextViewText(R.id.clipboard_item_type, type)
            views.setTextColor(R.id.clipboard_item_type, primaryColorInt)
            views.setTextViewText(R.id.clipboard_item_date, date)

            val fillInIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_OPEN_ITEM
                putExtra("clip_id", id)
                data = android.net.Uri.parse("copyclip://app/clipboard/edit?id=$id")
            }
            views.setOnClickFillInIntent(R.id.clipboard_item_root, fillInIntent)

            // Copy button click -> Copies clip content (does NOT open app)
            val copyIntent = Intent().apply {
                action = WidgetActionReceiver.ACTION_COPY_TEXT
                putExtra(WidgetActionReceiver.EXTRA_COPY_TEXT, content)
                putExtra(WidgetActionReceiver.EXTRA_COPY_LABEL, "Clip: $type")
            }
            views.setOnClickFillInIntent(R.id.clipboard_item_copy, copyIntent)
            
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
