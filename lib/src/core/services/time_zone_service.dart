import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class TimeZoneService {
  static final TimeZoneService _instance = TimeZoneService._internal();
  factory TimeZoneService() => _instance;
  TimeZoneService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      tz_data.initializeTimeZones();
      String timeZoneName;
      try {
        final dynamic localFn = await FlutterTimezone.getLocalTimezone();
        timeZoneName = localFn.toString();
      } catch (e) {
        timeZoneName = 'UTC';
      }

      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        debugPrint('✅ TimeZone initialized: $timeZoneName');
      } catch (e) {
        debugPrint(
          '⚠️ Local TimeZone location not found: $timeZoneName, trying UTC',
        );
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ TimeZone Initialization Failed: $e');
    }
  }

  /// Converts a GMT DateTime to Local Time
  DateTime convertToLocal(DateTime gmtTime) {
    if (!_isInitialized) {
      debugPrint('⚠️ TimeZoneService not initialized');
      return gmtTime.toLocal(); // Fallback
    }
    return tz.TZDateTime.from(gmtTime, tz.local);
  }

  /// Gets specific notification times based on current date
  /// [times]: List of tuples/maps (hour, minute)
  List<DateTime> getNotificationTimes(List<(int, int)> dailySchedules) {
    final now = DateTime.now();
    return dailySchedules.map((schedule) {
      return DateTime(now.year, now.month, now.day, schedule.$1, schedule.$2);
    }).toList();
  }
}
