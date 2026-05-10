package com.mescalories.mes_calories

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

/**
 * Widget home screen MesCalories.
 * Lit les données depuis HomeWidgetPreferences (mis à jour par Flutter via home_widget).
 */
class MesCaloriesWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            val prefs = context.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE,
            )

            val calories = prefs.getInt("calories_today", 0)
            val goal = prefs.getInt("calorie_goal", 2000)
            val progress = if (goal > 0) ((calories.toFloat() / goal) * 100).toInt().coerceIn(0, 100) else 0

            val views = RemoteViews(context.packageName, R.layout.mes_calories_widget)
            views.setTextViewText(R.id.tv_calories, calories.toString())
            views.setTextViewText(R.id.tv_goal, "/ $goal kcal")
            views.setProgressBar(R.id.pb_progress, 100, progress, false)

            // Ouvrir l'app au clic
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
