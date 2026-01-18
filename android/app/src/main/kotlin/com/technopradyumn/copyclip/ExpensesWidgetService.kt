package com.technopradyumn.copyclip

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class ExpensesWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return ExpensesRemoteViewsFactory(this.applicationContext)
    }
}

class ExpensesRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {
    private var dataArray = JSONArray()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        try {
            val widgetData = HomeWidgetPlugin.getData(context)
            val jsonStr = widgetData.getString("expenses_data", "[]")
            dataArray = JSONArray(jsonStr)
        } catch (e: Exception) {
            e.printStackTrace()
            dataArray = JSONArray()
        }
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return dataArray.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.finance_widget_item)
        try {
            val item = dataArray.getJSONObject(position)
            val title = item.optString("title", "Transaction")
            val amount = item.optString("amount", "$0")
            val date = item.optString("date", "")
            val isIncome = item.optBoolean("isIncome", false)
            val id = item.optString("id", "")

            views.setTextViewText(R.id.tx_title, title)
            views.setTextViewText(R.id.tx_date, date)
            views.setTextViewText(R.id.tx_amount, amount)

            if (isIncome) {
                views.setTextColor(R.id.tx_amount, android.graphics.Color.parseColor("#34C759")) // Green
            } else {
                views.setTextColor(R.id.tx_amount, android.graphics.Color.parseColor("#FF3B30")) // Red
            }

            val fillInIntent = Intent()
            fillInIntent.putExtra("expense_id", id)
            views.setOnClickFillInIntent(R.id.expense_item_root, fillInIntent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return views
    }

    override fun getLoadingView(): RemoteViews? { return null }
    override fun getViewTypeCount(): Int { return 1 }
    override fun getItemId(position: Int): Long { return position.toLong() }
    override fun hasStableIds(): Boolean { return true }
}
