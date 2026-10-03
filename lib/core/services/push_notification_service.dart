import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../config/app_config.dart';

/// OneSignal setup. OneSignal has no web SDK binding in Flutter, so it is
/// skipped on web (including the Docker build).
class PushNotificationService {
  PushNotificationService._();

  static void init({void Function(String? route)? onOpen}) {
    if (kIsWeb) return;
    try {
      if (kDebugMode) OneSignal.Debug.setLogLevel(OSLogLevel.warn);
      OneSignal.initialize(AppConfig.oneSignalAppId);
      OneSignal.Notifications.requestPermission(true);
      OneSignal.Notifications.addClickListener((event) {
        final route = event.notification.additionalData?['route'] as String?;
        onOpen?.call(route);
      });
    } catch (e) {
      debugPrint('Push notifications unavailable: $e');
    }
  }
}
