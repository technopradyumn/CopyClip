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

class TodosWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.todo_widget_layout)
            updateWidget(context, views, widgetId)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.todos_list)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews, widgetId: Int) {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            WidgetBackgroundHelper.applyBackground(context, views, widgetData)
            val progress = widgetData.getString("todos_progress", "0/0 Done")

            // Set Header & Title
            views.setTextViewText(R.id.widget_title, "To-Do List")

            // Bind New Views
            views.setTextViewText(R.id.todos_progress, progress)
            // views.setProgressBar(R.id.todos_progress_bar, 100, 0, false) // Removed: Not in XML
            // views.setImageViewResource(R.id.widget_icon, R.drawable.ic_widget) // Let XML handle icon

            // Bind List Adapter
            val serviceIntent = Intent(context, TodosWidgetService::class.java)
            serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            serviceIntent.data = Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME))
            
            views.setRemoteAdapter(R.id.todos_list, serviceIntent)
            views.setEmptyView(R.id.todos_list, R.id.empty_state)

            // Calculate hasTodos from progress text or check list
            // Or better, check the json data size too? But here we rely on the adapter.
            // But we need to toggle visibility. 
            // We can read "todos_data" string length or check if "0/0" -> likely empty?
            // Actually, in WidgetSyncService, we saved "todos_data".
            // Let's check if the json is empty.
            val jsonStr = widgetData.getString("todos_data", "[]") ?: "[]"
            val hasTodos = jsonStr != "[]" && jsonStr.length > 2

            if (hasTodos) {
                views.setViewVisibility(R.id.todos_list, View.VISIBLE)
                views.setViewVisibility(R.id.empty_state, View.GONE)
            } else {
                views.setViewVisibility(R.id.todos_list, View.GONE)
                views.setViewVisibility(R.id.empty_state, View.VISIBLE)
            }

            // Template for List Items (Edit & Toggle handled via WidgetActionReceiver)
            val templateIntent = Intent(context, WidgetActionReceiver::class.java)
            val itemPendingIntent = PendingIntent.getBroadcast(
                context, 101, templateIntent, // Unique Request Code
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            views.setPendingIntentTemplate(R.id.todos_list, itemPendingIntent)

            val intent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("copyclip://app/todos")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)
        } catch (e: Exception) {
            android.util.Log.e("TodosWidget", "Error updating widget", e)
        }
    }
}