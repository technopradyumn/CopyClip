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

class JournalWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.journal_widget_layout)
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.journal_list)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, appWidgetId: Int) {
        try {
            views.setTextViewText(R.id.widget_title, "My Journal")
            val dateFormat = java.text.SimpleDateFormat("EEE, MMM dd", java.util.Locale.getDefault())
            views.setTextViewText(R.id.today_date, dateFormat.format(java.util.Date()))

            // Set Adapter for List View
            val serviceIntent = Intent(context, JournalWidgetService::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            views.setRemoteAdapter(R.id.journal_list, serviceIntent)
            views.setEmptyView(R.id.journal_list, R.id.empty_state)

            // Manual Visibility Toggle (Like Notes Widget)
            val widgetData = HomeWidgetPlugin.getData(context)
            val totalEntries = widgetData.getInt("journal_total_entries", 0)
            if (totalEntries > 0) {
                views.setViewVisibility(R.id.journal_list, View.VISIBLE)
                views.setViewVisibility(R.id.empty_state, View.GONE)
            } else {
                views.setViewVisibility(R.id.journal_list, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Click Intent Template
            val clickIntent = Intent(context, MainActivity::class.java).apply {
                 action = Intent.ACTION_VIEW
                 flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            val clickPendingIntent = PendingIntent.getActivity(
                context, 0, clickIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.journal_list, clickPendingIntent)

            // Header Click - Use EXPLICIT Intent to ensure it launches the app
            val headerIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("copyclip://app/journal")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            // Use unique request code 1 for Journal to avoid conflicts
            val headerPendingIntent = PendingIntent.getActivity(
                context, 1, headerIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_header, headerPendingIntent)
            views.setOnClickPendingIntent(R.id.widget_title, headerPendingIntent)
            views.setOnClickPendingIntent(R.id.empty_state, headerPendingIntent)

        } catch (e: Exception) {
            e.printStackTrace()
            val errorViews = RemoteViews(context.packageName, R.layout.widget_error_layout)
             AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, errorViews)
        }
    }
}