package com.technopradyumn.copyclip

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import android.view.View

class CanvasWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.canvas_widget_layout)
            updateWidget(context, views)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun updateWidget(context: Context, views: RemoteViews) {
        views.setTextViewText(R.id.widget_title, "Canvas")

        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse("copyclip://canvas")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)

    }
}