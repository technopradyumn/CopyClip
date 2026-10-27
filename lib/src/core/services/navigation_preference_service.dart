import 'package:hive/hive.dart';

class NavigationPreferenceService {
  static const String _settingsBoxName = 'settings';
  static const String _lastDrawerRouteKey = 'last_drawer_route';

  static String? getLastDrawerRoute() {
    if (!Hive.isBoxOpen(_settingsBoxName)) return null;

    final route = Hive.box(_settingsBoxName).get(_lastDrawerRouteKey);
    return route is String ? route : null;
  }

  static Future<void> saveLastDrawerRoute(String route) {
    return Hive.box(_settingsBoxName).put(_lastDrawerRouteKey, route);
  }
}
