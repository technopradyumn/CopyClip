package com.technopradyumn.copyclip

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.view.View
import android.util.Log

class CopyClipWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "CopyClipWidget"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called for ${appWidgetIds.size} widgets")

        appWidgetIds.forEach { widgetId ->
            try {
                val views = RemoteViews(context.packageName, R.layout.widget_layout)
                updateWidgetContent(context, views)
                appWidgetManager.updateAppWidget(widgetId, views)
                Log.d(TAG, "Widget $widgetId updated successfully")
            } catch (e: Exception) {
                Log.e(TAG, "Error updating widget $widgetId", e)
            }
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d(TAG, "First widget added")
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d(TAG, "Last widget removed")
    }

    private fun updateWidgetContent(context: Context, views: RemoteViews) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)

            val widgetType = widgetData.getString("widget_type", "") ?: "notes"
            val widgetTitle = widgetData.getString("widget_title", "") ?: "CopyClip"
            val lastUpdate = widgetData.getString("last_update", "") ?: ""

            Log.d(TAG, "Widget Type: $widgetType, Title: $widgetTitle")

            // Update header
            views.setTextViewText(R.id.widget_title, widgetTitle)

            // ✅ Set click listener for entire widget
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("copyclip://$widgetType")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)

            // Update content based on widget type
            when (widgetType) {
                "notes" -> updateNotesWidget(views, widgetData, context)
                "todos" -> updateTodosWidget(views, widgetData, context)
                "expenses" -> updateExpensesWidget(views, widgetData, context)
                "journal" -> updateJournalWidget(views, widgetData, context)
                "clipboard" -> updateClipboardWidget(views, widgetData, context)
                "calendar" -> updateCalendarWidget(views, widgetData, context)
                "canvas" -> updateCanvasWidget(views, widgetData, context)
                else -> updateDefaultWidget(views)
            }


        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget content", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateNotesWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {
            showItems(views)

            // ✅ Add click handlers for each item
            addItemClickHandlers(views, context, "notes")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating notes widget", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateTodosWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {
            showItems(views)

            addItemClickHandlers(views, context, "todos")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating todos widget", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateExpensesWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {
            showItems(views)

            addItemClickHandlers(views, context, "expenses")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating expenses widget", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateJournalWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {

            addItemClickHandlers(views, context, "journal")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating journal widget", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateClipboardWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {
            showItems(views)

            addItemClickHandlers(views, context, "clipboard")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating clipboard widget", e)
            updateDefaultWidget(views)
        }
    }

    private fun updateCalendarWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {

            addItemClickHandlers(views, context, "calendar")
        } catch (e: Exception) {
            updateDefaultWidget(views)
        }
    }

    private fun updateCanvasWidget(
        views: RemoteViews,
        data: android.content.SharedPreferences,
        context: Context
    ) {
        try {

            addItemClickHandlers(views, context, "canvas")
        } catch (e: Exception) {
            updateDefaultWidget(views)
        }
    }

    private fun updateDefaultWidget(views: RemoteViews) {

    }

    // ✅ Add click handlers for items
    private fun addItemClickHandlers(
        views: RemoteViews,
        context: Context,
        featureType: String
    ) {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse("copyclip://$featureType")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun showItems(views: RemoteViews) {

    }

    private fun formatUpdateTime(isoString: String): String {
        return if (isoString.isEmpty()) {
            "Just now"
        } else {
            "Updated"
        }
    }
}