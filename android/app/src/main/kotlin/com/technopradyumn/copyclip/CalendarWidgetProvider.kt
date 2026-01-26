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
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.calendar_list)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, appWidgetId: Int) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val eventsCount = widgetData.getString("events_count", "0 events")
            val hasEvents = widgetData.getBoolean("has_events", false)

            views.setTextViewText(R.id.widget_title, "Today") // or Schedule
            views.setTextViewText(R.id.events_count, eventsCount)

            // Set Adapter for List View
            val serviceIntent = Intent(context, CalendarWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.calendar_list, serviceIntent)
            views.setEmptyView(R.id.calendar_list, R.id.empty_state)

            // Visibility Logic
            if (hasEvents) {
                views.setViewVisibility(R.id.calendar_list, View.VISIBLE)
                views.setViewVisibility(R.id.empty_state, View.GONE)
            } else {
                views.setViewVisibility(R.id.calendar_list, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Click Intent (Root Header opens Calendar)
            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("copyclip://app/calendar")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId, intent, // Unique ID per widget instance
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
            
            // Redundant listener for empty state
            views.setOnClickPendingIntent(R.id.empty_state, pendingIntent)
            
            // List Item Click Template
             val clickIntentTemplate = Intent(context, MainActivity::class.java).apply {
                 action = Intent.ACTION_VIEW
                 flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val clickPendingIntentTemplate = PendingIntent.getActivity(
                context, appWidgetId + 1000, clickIntentTemplate,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.calendar_list, clickPendingIntentTemplate)

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}