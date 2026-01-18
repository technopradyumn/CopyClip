# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.mediation.** { *; }

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# ✅ OPTIMIZATION: Keep widget providers
-keep class com.technopradyumn.copyclip.*WidgetProvider { *; }

# Hive
-keep class * extends com.hivedb.** { *; }
-keepclassmembers class * extends com.hivedb.** { *; }

# Home Widget
-keep class es.antonborri.home_widget.** { *; }

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# ✅ FIX: Play Core & Feature Delivery (R8 Issues)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**

# ✅ OPTIMIZATION: Remove debug logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# ✅ OPTIMIZATION: Aggressive optimization settings
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
