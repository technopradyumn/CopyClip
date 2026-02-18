import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

/// Service to handle app update checking with proper caching.
/// This ensures the update popup only shows when there's actually a new version.
class AppUpdateService {
  static const String _lastCheckTimeKey = 'app_update_last_check_time';
  static const String _latestVersionKey = 'app_update_latest_version';
  static const String _currentVersionAtCheckKey =
      'app_update_current_version_at_check';
  static const String _updateAvailableKey = 'app_update_available';

  // Minimum time between store checks (to avoid excessive API calls)
  static const Duration _minCheckInterval = Duration(hours: 6);

  static AppUpdateService? _instance;
  static AppUpdateService get instance => _instance ??= AppUpdateService._();

  AppUpdateService._();

  String? _currentVersion;
  String? _latestVersion;
  bool _isUpdateAvailable = false;
  bool _hasChecked = false;

  Completer<bool>? _checkCompleter;

  /// Get current app version
  String? get currentVersion => _currentVersion;

  /// Get latest available version from store
  String? get latestVersion => _latestVersion;

  /// Check if an update is available
  bool get isUpdateAvailable => _isUpdateAvailable;

  /// Check if we've already performed a check this session
  bool get hasChecked => _hasChecked;

  /// Initialize the service and check for updates.
  /// Call this once at app startup.
  Future<bool> checkForUpdate({bool forceCheck = false}) async {
    _checkCompleter = Completer<bool>();
    try {
      final prefs = await SharedPreferences.getInstance();
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;

      debugPrint('AppUpdateService: Current version: $_currentVersion');

      // Check if we need to do a fresh check
      final lastCheckTime = prefs.getInt(_lastCheckTimeKey) ?? 0;
      final lastCheckDateTime = DateTime.fromMillisecondsSinceEpoch(
        lastCheckTime,
      );
      final timeSinceLastCheck = DateTime.now().difference(lastCheckDateTime);
      final currentVersionAtCheck = prefs.getString(_currentVersionAtCheckKey);

      // We need a fresh check if:
      // 1. Force check requested
      // 2. Never checked before
      // 3. Check interval has passed
      // 4. App was updated since last check (user updated the app)
      final needsFreshCheck =
          forceCheck ||
          lastCheckTime == 0 ||
          timeSinceLastCheck > _minCheckInterval ||
          currentVersionAtCheck != _currentVersion;

      if (needsFreshCheck) {
        debugPrint('AppUpdateService: Performing fresh store check...');
        await _performStoreCheck(prefs, packageInfo);
      } else {
        // Use cached result
        _latestVersion = prefs.getString(_latestVersionKey);
        _isUpdateAvailable = prefs.getBool(_updateAvailableKey) ?? false;
        debugPrint(
          'AppUpdateService: Using cached result. Update available: $_isUpdateAvailable',
        );
      }

      _hasChecked = true;
      _checkCompleter?.complete(_isUpdateAvailable);
      return _isUpdateAvailable;
    } catch (e) {
      debugPrint('AppUpdateService: Error checking for update: $e');
      _hasChecked = true;
      _checkCompleter?.complete(false);
      return false;
    }
  }

  /// Wait for the background update check to complete.
  /// Returns true if an update is available, false otherwise.
  Future<bool> waitForCheck() async {
    if (_hasChecked) return _isUpdateAvailable;
    return _checkCompleter?.future ?? Future.value(false);
  }

  /// Perform actual store check using upgrader package
  Future<void> _performStoreCheck(
    SharedPreferences prefs,
    PackageInfo packageInfo,
  ) async {
    try {
      final upgrader = Upgrader(debugLogging: kDebugMode, countryCode: 'IN');

      // Initialize upgrader to fetch store info
      await upgrader.initialize();

      // Wait a moment for the version info to be fetched
      await Future.delayed(const Duration(milliseconds: 500));

      final storeVersion = upgrader.currentAppStoreVersion;

      if (storeVersion != null && storeVersion.isNotEmpty) {
        _latestVersion = storeVersion;
        _isUpdateAvailable =
            _compareVersions(_currentVersion!, storeVersion) < 0;

        debugPrint('AppUpdateService: Store version: $storeVersion');
        debugPrint('AppUpdateService: Current version: $_currentVersion');
        debugPrint('AppUpdateService: Update available: $_isUpdateAvailable');

        // Cache the result
        await prefs.setInt(
          _lastCheckTimeKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        await prefs.setString(_latestVersionKey, storeVersion);
        await prefs.setString(_currentVersionAtCheckKey, _currentVersion!);
        await prefs.setBool(_updateAvailableKey, _isUpdateAvailable);
      } else {
        debugPrint('AppUpdateService: Could not fetch store version');
        _isUpdateAvailable = false;
        await prefs.setBool(_updateAvailableKey, false);
      }
    } catch (e) {
      debugPrint('AppUpdateService: Store check failed: $e');
      _isUpdateAvailable = false;
    }
  }

  /// Compare two version strings.
  /// Returns: negative if v1 < v2, zero if equal, positive if v1 > v2
  int _compareVersions(String v1, String v2) {
    // Remove any non-numeric suffixes (like -beta, +build)
    v1 = v1.split(RegExp(r'[-+]')).first;
    v2 = v2.split(RegExp(r'[-+]')).first;

    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad with zeros if needed
    while (parts1.length < 3) {
      parts1.add(0);
    }
    while (parts2.length < 3) {
      parts2.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }
    return 0;
  }

  /// Clear all cached data (useful for testing or when user wants to force refresh)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastCheckTimeKey);
    await prefs.remove(_latestVersionKey);
    await prefs.remove(_currentVersionAtCheckKey);
    await prefs.remove(_updateAvailableKey);
    _hasChecked = false;
    _isUpdateAvailable = false;
    _latestVersion = null;
    debugPrint('AppUpdateService: Cache cleared');
  }

  /// Get store URL for the app based on platform
  String getStoreUrl() {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.technopradyumn.copyclip';
    }
    return '';
  }
}
