package com.technopradyumn.copyclip

import android.content.Context
import android.content.SharedPreferences
import android.graphics.*
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import kotlin.random.Random

object WidgetBackgroundHelper {

    private const val TAG = "WidgetBackgroundHelper"

    fun applyBackground(context: Context, views: RemoteViews, data: SharedPreferences? = null) {
        try {
            val widgetData = data ?: HomeWidgetPlugin.getData(context)
            val allData = widgetData.all

            val primaryColorInt = when (val colorRaw = allData["primary_color"]) {
                is Number -> colorRaw.toInt()
                is String -> colorRaw.toIntOrNull() ?: Color.parseColor("#6366F1")
                else -> {
                    val strVal = widgetData.getString("primary_color_str", null)
                    strVal?.toIntOrNull() ?: Color.parseColor("#6366F1")
                }
            }

            // Dynamically apply app Primary Color to widget header icons and accent badges
            try {
                views.setInt(R.id.widget_icon, "setColorFilter", primaryColorInt)
            } catch (_: Exception) {}

            try {
                views.setTextColor(R.id.notes_count, primaryColorInt)
            } catch (_: Exception) {}

            try {
                views.setTextColor(R.id.todos_progress, primaryColorInt)
            } catch (_: Exception) {}

            try {
                views.setTextColor(R.id.today_date, primaryColorInt)
            } catch (_: Exception) {}

            val allowRaw = allData["apply_app_background"]
            val allowBackground = when (allowRaw) {
                is Boolean -> allowRaw
                is String -> allowRaw.toBoolean()
                else -> {
                    val strVal = widgetData.getString("apply_app_background_str", null)
                    strVal?.toBoolean() ?: true
                }
            }

            Log.d(TAG, "applyBackground called, allowBackground: $allowBackground, primaryColor: $primaryColorInt")

            if (!allowBackground) {
                val themeMode = widgetData.getString("theme_mode", "system") ?: "system"
                val isDark = isDarkMode(context, themeMode)
                val solidBgColor = if (isDark) Color.parseColor("#1C1C1E") else Color.WHITE

                val width = 600
                val height = 400
                val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bitmap)

                val rect = RectF(0f, 0f, width.toFloat(), height.toFloat())
                val cornerRadius = 48f
                val path = Path().apply {
                    addRoundRect(rect, cornerRadius, cornerRadius, Path.Direction.CW)
                }
                canvas.clipPath(path)

                canvas.drawColor(solidBgColor)

                val borderPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    style = Paint.Style.STROKE
                    strokeWidth = 3f
                    color = if (isDark) Color.argb(35, 255, 255, 255) else Color.argb(25, 0, 0, 0)
                }
                canvas.drawRoundRect(rect, cornerRadius, cornerRadius, borderPaint)

                views.setImageViewBitmap(R.id.widget_bg_image, bitmap)
                views.setViewVisibility(R.id.widget_bg_image, View.VISIBLE)
                return
            }

            val designName = widgetData.getString("background_design", "classicBubbles") ?: "classicBubbles"
            val themeMode = widgetData.getString("theme_mode", "system") ?: "system"

            Log.d(TAG, "Drawing widget background design: $designName, mode: $themeMode, color: $primaryColorInt")

            // Generate a high-quality bitmap pattern matching the Flutter background design
            val width = 600
            val height = 400
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)

            drawBackgroundDesign(context, canvas, width, height, designName, primaryColorInt, themeMode)

            views.setImageViewBitmap(R.id.widget_bg_image, bitmap)
            views.setViewVisibility(R.id.widget_bg_image, View.VISIBLE)
        } catch (e: Exception) {
            Log.e(TAG, "Error applying widget background", e)
            try {
                views.setViewVisibility(R.id.widget_bg_image, View.GONE)
            } catch (_: Exception) {}
        }
    }

    private fun isDarkMode(context: Context, themeMode: String): Boolean {
        return when (themeMode) {
            "dark" -> true
            "light" -> false
            else -> {
                try {
                    val nightMode = context.resources.configuration.uiMode and android.content.res.Configuration.UI_MODE_NIGHT_MASK
                    nightMode == android.content.res.Configuration.UI_MODE_NIGHT_YES
                } catch (_: Exception) {
                    false
                }
            }
        }
    }

    private fun drawBackgroundDesign(
        context: Context,
        canvas: Canvas,
        w: Int,
        h: Int,
        design: String,
        primaryColor: Int,
        themeMode: String
    ) {
        val isDark = isDarkMode(context, themeMode)

        val rect = RectF(0f, 0f, w.toFloat(), h.toFloat())
        val cornerRadius = 48f
        val path = Path().apply {
            addRoundRect(rect, cornerRadius, cornerRadius, Path.Direction.CW)
        }
        canvas.clipPath(path)

        // 1. Scaffold background color matching Flutter app (AppColors.backgroundDark #111827 or Light #F9FAFB)
        val scaffoldBg = if (isDark) Color.parseColor("#111827") else Color.parseColor("#F9FAFB")
        val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = scaffoldBg }
        canvas.drawRect(rect, bgPaint)

        // 2. Base gradient with primary color tint
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val (bgStart, bgEnd) = getDesignGradientColors(design, primaryColor, isDark)
        val baseGradient = LinearGradient(
            0f, 0f, w.toFloat(), h.toFloat(),
            bgStart, bgEnd,
            Shader.TileMode.CLAMP
        )
        paint.shader = baseGradient
        canvas.drawRect(rect, paint)
        paint.shader = null

        // 3. Overlay pattern accents matching Flutter painters
        when (design) {
            "classicBubbles" -> drawBubbles(canvas, w, h, primaryColor, isDark)
            "floatingStars" -> drawStars(canvas, w, h, isDark)
            "meshGradient" -> drawMeshOverlay(canvas, w, h, primaryColor)
            "nebulaCloud" -> drawNebula(canvas, w, h, primaryColor)
            "particleFlow" -> drawParticles(canvas, w, h)
            "geometricFloat" -> drawGeometry(canvas, w, h, isDark)
            "snowfall" -> drawSnow(canvas, w, h, isDark)
            "matrixRain" -> drawMatrix(canvas, w, h)
            "waveMotion" -> drawWaves(canvas, w, h)
            "bokehBlur" -> drawBokeh(canvas, w, h)
            "aurora" -> drawAurora(canvas, w, h)
            "magicalSpells" -> drawSpells(canvas, w, h)
            "deepForest" -> drawForest(canvas, w, h)
            else -> { /* Solid or clean gradient */ }
        }

        // 4. Subtle outer border around the widget edge
        val borderPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = 3f
            this.color = if (isDark) Color.argb(35, 255, 255, 255) else Color.argb(25, 0, 0, 0)
        }
        canvas.drawRoundRect(rect, cornerRadius, cornerRadius, borderPaint)
    }

    private fun getDesignGradientColors(design: String, primaryColor: Int, isDark: Boolean): Pair<Int, Int> {
        val r = Color.red(primaryColor)
        val g = Color.green(primaryColor)
        val b = Color.blue(primaryColor)

        if (isDark) {
            val tintedStart = Color.argb(220, (r * 0.35).toInt(), (g * 0.35).toInt(), (b * 0.45).toInt())
            return when (design) {
                "classicBubbles" -> Pair(tintedStart, Color.parseColor("#0F172A"))
                "floatingStars" -> Pair(Color.parseColor("#0B0F19"), Color.parseColor("#111827"))
                "meshGradient" -> Pair(Color.parseColor("#2E1065"), Color.parseColor("#1E1B4B"))
                "nebulaCloud" -> Pair(Color.parseColor("#18002E"), Color.parseColor("#0F051D"))
                "particleFlow" -> Pair(Color.parseColor("#042F2E"), Color.parseColor("#0F172A"))
                "geometricFloat" -> Pair(Color.parseColor("#18181B"), Color.parseColor("#27272A"))
                "snowfall" -> Pair(Color.parseColor("#0C4A6E"), Color.parseColor("#0F172A"))
                "matrixRain" -> Pair(Color.parseColor("#022C22"), Color.parseColor("#051F14"))
                "waveMotion" -> Pair(Color.parseColor("#075985"), Color.parseColor("#0C4A6E"))
                "bokehBlur" -> Pair(Color.parseColor("#1F1937"), Color.parseColor("#0F172A"))
                "aurora" -> Pair(Color.parseColor("#064E3B"), Color.parseColor("#1E1B4B"))
                "magicalSpells" -> Pair(Color.parseColor("#311B92"), Color.parseColor("#1A237E"))
                "deepForest" -> Pair(Color.parseColor("#052E16"), Color.parseColor("#021A0D"))
                else -> Pair(Color.parseColor("#111827"), Color.parseColor("#0F172A"))
            }
        } else {
            val lightBg = Color.parseColor("#F9FAFB")
            val tintedStart = Color.argb(
                255,
                ((Color.red(lightBg) * 0.93) + (r * 0.07)).toInt().coerceIn(0, 255),
                ((Color.green(lightBg) * 0.93) + (g * 0.07)).toInt().coerceIn(0, 255),
                ((Color.blue(lightBg) * 0.93) + (b * 0.07)).toInt().coerceIn(0, 255)
            )
            return Pair(tintedStart, lightBg)
        }
    }

    private fun drawBubbles(canvas: Canvas, w: Int, h: Int, primaryColor: Int, isDark: Boolean) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { style = Paint.Style.FILL }
        val random = Random(42)
        val alpha = if (isDark) 45 else 30
        for (i in 0..6) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            val radius = 40f + random.nextFloat() * 80f
            paint.color = Color.argb(alpha, Color.red(primaryColor), Color.green(primaryColor), Color.blue(primaryColor))
            canvas.drawCircle(cx, cy, radius, paint)
        }
    }

    private fun drawStars(canvas: Canvas, w: Int, h: Int, isDark: Boolean) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = if (isDark) Color.argb(180, 255, 255, 255) else Color.argb(120, 99, 102, 241)
            style = Paint.Style.FILL
        }
        val random = Random(123)
        for (i in 0..30) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            val r = 1.5f + random.nextFloat() * 3f
            canvas.drawCircle(cx, cy, r, paint)
        }
    }

    private fun drawMeshOverlay(canvas: Canvas, w: Int, h: Int, primaryColor: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val shader = RadialGradient(
            w * 0.7f, h * 0.3f, w * 0.6f,
            Color.argb(80, Color.red(primaryColor), Color.green(primaryColor), Color.blue(primaryColor)),
            Color.TRANSPARENT,
            Shader.TileMode.CLAMP
        )
        paint.shader = shader
        canvas.drawRect(0f, 0f, w.toFloat(), h.toFloat(), paint)
    }

    private fun drawNebula(canvas: Canvas, w: Int, h: Int, primaryColor: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val shader = RadialGradient(
            w * 0.3f, h * 0.5f, w * 0.5f,
            Color.argb(90, Color.red(primaryColor), Color.green(primaryColor), Color.blue(primaryColor)),
            Color.TRANSPARENT,
            Shader.TileMode.CLAMP
        )
        paint.shader = shader
        canvas.drawRect(0f, 0f, w.toFloat(), h.toFloat(), paint)
    }

    private fun drawParticles(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(140, 45, 212, 191)
            style = Paint.Style.FILL
        }
        val random = Random(99)
        for (i in 0..20) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            canvas.drawCircle(cx, cy, 3f + random.nextFloat() * 4f, paint)
        }
    }

    private fun drawGeometry(canvas: Canvas, w: Int, h: Int, isDark: Boolean) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = 2f
            this.color = if (isDark) Color.argb(50, 255, 255, 255) else Color.argb(40, 0, 0, 0)
        }
        canvas.drawCircle(w * 0.8f, h * 0.2f, 60f, paint)
        canvas.drawRect(20f, h - 80f, 100f, h - 20f, paint)
    }

    private fun drawSnow(canvas: Canvas, w: Int, h: Int, isDark: Boolean) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = if (isDark) Color.argb(160, 255, 255, 255) else Color.argb(100, 14, 165, 233)
            style = Paint.Style.FILL
        }
        val random = Random(77)
        for (i in 0..25) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            canvas.drawCircle(cx, cy, 2f + random.nextFloat() * 3f, paint)
        }
    }

    private fun drawMatrix(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(90, 34, 197, 94)
            textSize = 20f
            typeface = Typeface.MONOSPACE
        }
        val chars = "0110100101"
        for (i in 0..10) {
            val str = chars.substring(i % chars.length, (i % chars.length) + 1)
            canvas.drawText(str, (i * 55).toFloat() + 10, ((i * 35) % h).toFloat() + 30, paint)
        }
    }

    private fun drawWaves(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.FILL
            this.color = Color.argb(45, 14, 165, 233)
        }
        val path = Path().apply {
            moveTo(0f, h * 0.6f)
            quadTo(w * 0.25f, h * 0.4f, w * 0.5f, h * 0.6f)
            quadTo(w * 0.75f, h * 0.8f, w.toFloat(), h * 0.6f)
            lineTo(w.toFloat(), h.toFloat())
            lineTo(0f, h.toFloat())
            close()
        }
        canvas.drawPath(path, paint)
    }

    private fun drawBokeh(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.FILL
        }
        val random = Random(55)
        for (i in 0..5) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            val r = 50f + random.nextFloat() * 70f
            paint.color = Color.argb(40, 244, 63, 94)
            canvas.drawCircle(cx, cy, r, paint)
        }
    }

    private fun drawAurora(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val shader = LinearGradient(
            0f, 0f, w.toFloat(), 0f,
            intArrayOf(Color.argb(80, 16, 185, 129), Color.argb(80, 139, 92, 246), Color.argb(80, 59, 130, 246)),
            null,
            Shader.TileMode.CLAMP
        )
        paint.shader = shader
        canvas.drawRect(0f, 0f, w.toFloat(), h.toFloat(), paint)
    }

    private fun drawSpells(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(160, 236, 72, 153)
            style = Paint.Style.FILL
        }
        val random = Random(33)
        for (i in 0..15) {
            val cx = random.nextFloat() * w
            val cy = random.nextFloat() * h
            canvas.drawCircle(cx, cy, 2.5f + random.nextFloat() * 3f, paint)
        }
    }

    private fun drawForest(canvas: Canvas, w: Int, h: Int) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(60, 20, 83, 45)
            style = Paint.Style.FILL
        }
        canvas.drawRect(0f, h * 0.7f, w.toFloat(), h.toFloat(), paint)
    }
}
