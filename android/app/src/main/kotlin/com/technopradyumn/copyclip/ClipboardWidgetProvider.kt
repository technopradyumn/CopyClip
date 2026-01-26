package com.technopradyumn.copyclip

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.view.View

class ClipboardWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.clipboard_widget_layout)
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, widgetId: Int) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            views.setTextViewText(R.id.widget_title, "Clipboard")

            // Bind List Adapter
            val serviceIntent = Intent(context, ClipboardWidgetService::class.java)
            serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            serviceIntent.data = Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))
            
            views.setRemoteAdapter(R.id.clipboard_list, serviceIntent)
            
            // Check for list data
            val jsonStr = widgetData.getString("clipboard_data", "[]")
            val hasList = jsonStr != "[]" && jsonStr != null && jsonStr.length > 2

            if (hasList) {
                views.setViewVisibility(R.id.clipboard_list, View.VISIBLE)
                views.setViewVisibility(R.id.latest_clip_card, View.GONE)
            } else {
                views.setViewVisibility(R.id.clipboard_list, View.GONE)
                views.setViewVisibility(R.id.latest_clip_card, View.VISIBLE)
                
                val latestClip = widgetData.getString("latest_clip_content", "No clips yet")
                views.setTextViewText(R.id.latest_clip_content, latestClip)
            }

            // Template for List Items
            val itemIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val itemPendingIntent = PendingIntent.getActivity(
                context, 102, itemIntent, // Unique Request Code
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.clipboard_list, itemPendingIntent)

            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("copyclip://app/clipboard")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
        } catch (e: Exception) {
            android.util.Log.e("ClipboardWidget", "Error updating widget", e)
        }
    }
}