import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../config/app_config.dart';

/// OneSignal setup for the supported Android and iOS platforms.
class PushNotificationService {
  PushNotificationService._();

  static void init({void Function(String? route)? onOpen}) {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
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
