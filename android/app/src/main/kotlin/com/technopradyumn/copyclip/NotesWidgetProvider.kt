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

class NotesWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.note_widget_layout)
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.notes_list)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, widgetId: Int) {
        try {
            // Get Data from Flutter
            val widgetData = HomeWidgetPlugin.getData(context)
            WidgetBackgroundHelper.applyBackground(context, views, widgetData)
            val notesCount = widgetData.getString("notes_count", "0 Notes")

            // Set Header & Title
            views.setTextViewText(R.id.widget_title, "Recent Notes")
            
            // Bind New Views
            views.setTextViewText(R.id.notes_count, notesCount)
            // views.setImageViewResource(R.id.widget_icon, R.drawable.ic_widget) // Let XML handle icon
            
            // Bind List Adapter
            val serviceIntent = Intent(context, NotesWidgetService::class.java)
            // Add appWidgetId to intent to distinguish different widgets if needed
            serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            serviceIntent.data = Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))
            
            views.setRemoteAdapter(R.id.notes_list, serviceIntent)
            views.setEmptyView(R.id.notes_list, R.id.empty_state)

            // Toggle Visibility
            val jsonStr = widgetData.getString("notes_data", "[]") ?: "[]"
            val hasNotes = jsonStr != "[]" && jsonStr.length > 2
            if (hasNotes) {
                views.setViewVisibility(R.id.notes_list, View.VISIBLE)
                views.setViewVisibility(R.id.empty_state, View.GONE)
            } else {
                views.setViewVisibility(R.id.notes_list, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Template for List Items (Item Click & Copy handled via WidgetActionReceiver)
            val templateIntent = Intent(context, WidgetActionReceiver::class.java)
            val itemPendingIntent = PendingIntent.getBroadcast(
                context, 100, templateIntent, // Unique Request Code
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE // MUTABLE required for fillInIntent
            )
            views.setPendingIntentTemplate(R.id.notes_list, itemPendingIntent)

            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("copyclip://app/notes")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
        } catch (e: Exception) {
            android.util.Log.e("NotesWidget", "Error updating widget", e)
        }
    }
}