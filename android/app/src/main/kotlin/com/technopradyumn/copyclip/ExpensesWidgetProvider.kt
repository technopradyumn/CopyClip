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
                appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.expenses_list)
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
        val income = widgetData.getString("income_amount", "$0") ?: "$0"
        val expense = widgetData.getString("expense_amount", "$0") ?: "$0"

        val incomeVal = (widgetData.getString("income_val", "0") ?: "0").toDoubleOrNull() ?: 0.0
        val expenseVal = (widgetData.getString("expense_val", "0") ?: "0").toDoubleOrNull() ?: 0.0

        views.setTextViewText(R.id.widget_title, "Finance")

        // Bind Text (Safe)
        views.setTextViewText(R.id.total_balance, balance)
        views.setTextViewText(R.id.income_amount, income)
        views.setTextViewText(R.id.expense_amount, expense)

        // Bind Progress Bars
        val maxVal = (incomeVal + expenseVal).toInt()
        val safeMax = if (maxVal > 0) maxVal else 100
        
        views.setProgressBar(R.id.income_bar, safeMax, incomeVal.toInt(), false)
        views.setProgressBar(R.id.expense_bar, safeMax, expenseVal.toInt(), false)
        
        val intent = Intent(Intent.ACTION_VIEW).apply {
            data = Uri.parse("copyclip://expenses")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        views.setOnClickPendingIntent(R.id.widget_header, pendingIntent)

        // Bind List View
        val serviceIntent = Intent(context, ExpensesWidgetService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        views.setRemoteAdapter(R.id.expenses_list, serviceIntent)
        views.setEmptyView(R.id.expenses_list, R.id.empty_state)

        // Manual Visibility
        val count = widgetData.getInt("expenses_count", 0)
        if (count > 0) {
            views.setViewVisibility(R.id.expenses_list, View.VISIBLE)
            views.setViewVisibility(R.id.empty_state, View.GONE)
        } else {
            views.setViewVisibility(R.id.expenses_list, View.GONE)
            views.setViewVisibility(R.id.empty_state, View.VISIBLE)
        }
        
        // List Click Template
        val listClickIntent = Intent(Intent.ACTION_VIEW).apply {
             data = Uri.parse("copyclip://expenses/edit") 
             flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val listPendingIntent = PendingIntent.getActivity(
            context, 0, listClickIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        views.setPendingIntentTemplate(R.id.expenses_list, listPendingIntent)

    }
}