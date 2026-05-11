package com.mescalories.mes_calories

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.mescalories.app/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidget") {
                    val caloriesToday = call.argument<Int>("calories_today") ?: 0
                    val calorieGoal = call.argument<Int>("calorie_goal") ?: 2000

                    // Écrire dans le namespace lu par MesCaloriesWidget.kt
                    val prefs = context.getSharedPreferences(
                        "HomeWidgetPreferences",
                        Context.MODE_PRIVATE
                    )
                    prefs.edit()
                        .putInt("calories_today", caloriesToday)
                        .putInt("calorie_goal", calorieGoal)
                        .apply()

                    // Demander la mise à jour visuelle du widget
                    val manager = AppWidgetManager.getInstance(context)
                    val ids = manager.getAppWidgetIds(
                        ComponentName(context, MesCaloriesWidget::class.java)
                    )
                    for (id in ids) {
                        MesCaloriesWidget().onUpdate(context, manager, intArrayOf(id))
                    }

                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
