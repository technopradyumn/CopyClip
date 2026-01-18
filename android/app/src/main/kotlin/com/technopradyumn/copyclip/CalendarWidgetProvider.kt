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

class CalendarWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.calender_widget_layout)
            updateWidget(context, views)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val eventsCount = widgetData.getString("events_count", "0 events")

            views.setTextViewText(R.id.widget_title, "Schedule")
            
            // Bind New Views
            // views.setTextViewText(R.id.today_date, ... ) // Removed: Not in XML
            views.setTextViewText(R.id.events_count, eventsCount) // Correct XML ID
            // views.setImageViewResource(R.id.widget_icon, R.drawable.ic_widget) // Let XML handle

            // Default State
            views.setViewVisibility(R.id.empty_state, View.VISIBLE)

            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("copyclip://calendar")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
        } catch (e: Exception) {
            android.util.Log.e("CalendarWidget", "Error updating widget", e)
        }
    }
}