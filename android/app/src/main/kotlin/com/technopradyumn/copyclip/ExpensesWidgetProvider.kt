package com.technopradyumn.copyclip

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin


class ExpensesWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val views = RemoteViews(context.packageName, R.layout.finance_widget_layout)
                updateWidgetData(context, views)
                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (e: Exception) {
                e.printStackTrace()
                val errorViews = RemoteViews(context.packageName, R.layout.widget_error_layout)
                
                // Self-Update Intent (Tap to Refresh)
                val updateIntent = Intent(context, ExpensesWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(widgetId))
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context, widgetId, updateIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                errorViews.setOnClickPendingIntent(R.id.error_root_layout, pendingIntent)
                
                appWidgetManager.updateAppWidget(widgetId, errorViews)
            }
        }
    }

    private fun updateWidgetData(context: Context, views: RemoteViews) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val balance = widgetData.getString("total_balance", "$0.00") ?: "$0.00"

        // Set Title
        // views.setTextViewText(R.id.widget_title, "Total Balance") // Already set in XML

        // Bind Text (Safe)
        views.setTextViewText(R.id.total_balance, balance)

        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse("copyclip://app/expenses")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)

    }
}