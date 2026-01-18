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

class CanvasWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.canvas_widget_layout)
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.canvas_list)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, appWidgetId: Int) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val canvasCount = widgetData.getString("canvas_count", "0 sketches")

            views.setTextViewText(R.id.widget_title, "Canvas")
            views.setTextViewText(R.id.canvas_count, canvasCount)

            // Set Adapter for List View
            val serviceIntent = Intent(context, CanvasWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.canvas_list, serviceIntent)
            views.setEmptyView(R.id.canvas_list, R.id.empty_state)

            // Manual Visibility Toggle
            val countStr = (canvasCount ?: "0").split(" ")[0].toIntOrNull() ?: 0
            if (countStr > 0) {
                views.setViewVisibility(R.id.canvas_list, View.VISIBLE)
                views.setViewVisibility(R.id.empty_state, View.GONE)
            } else {
                views.setViewVisibility(R.id.canvas_list, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Click Intent Template
            val clickIntent = Intent(Intent.ACTION_VIEW).apply {
                 data = Uri.parse("copyclip://canvas/edit") // Handle deep link in MainActivity
                 flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val clickPendingIntent = PendingIntent.getActivity(
                context, 0, clickIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.canvas_list, clickPendingIntent)

            // Header Click
            val headerIntent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("copyclip://canvas")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val headerPendingIntent = PendingIntent.getActivity(
                context, 1, headerIntent, // RequestCode 1 to avoid conflict
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_header, headerPendingIntent)

        } catch (e: Exception) {
            e.printStackTrace()
             val errorViews = RemoteViews(context.packageName, R.layout.widget_error_layout)
             val intent = Intent(context, JournalWidgetProvider::class.java).apply {
                 action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                 putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
             }
             val pendingIntent = PendingIntent.getBroadcast(
                 context, appWidgetId, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
             )
             errorViews.setOnClickPendingIntent(R.id.widget_header, pendingIntent) 
             AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, errorViews)
        }
    }
}