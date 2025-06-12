import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import '../utils.dart';

class AppsFlyerService {
  late AppsflyerSdk appsflyerSdk;

  Future<void> initAppsFlyer({
    required String devKey,
    required String appId,
    bool isDebug = false,
  }) async {
    try {
      // Запрашиваем разрешение на отслеживание для iOS
      if (Platform.isIOS) {
        final TrackingStatus status =
            await AppTrackingTransparency.trackingAuthorizationStatus;

        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }

        // Получаем IDFA после запроса разрешения
        final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
        logger('IDFA: $idfa');
      }

      // Инициализация AppsFlyer
      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: devKey,
        appId: appId,
        showDebug: isDebug,
        timeToWaitForATTUserAuthorization: 15,
      );

      appsflyerSdk = AppsflyerSdk(options);

      // Инициализация SDK
      await appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      // Запуск SDK
      appsflyerSdk.startSDK();

      // Обработка данных конверсии
      appsflyerSdk.onInstallConversionData((data) {
        logger('Conversion Data: $data');
        if (data['status'] == 'success') {
          // Обработка успешной конверсии
          final payload = Map<String, dynamic>.from(data['payload'] as Map);
          logger('Payload: $payload');
        }
      });

      // Обработка deep link
      appsflyerSdk.onAppOpenAttribution((data) {
        logger('App Open Attribution: $data');
      });

      logger('AppsFlyer initialized successfully');
    } catch (e) {
      logger('Error initializing AppsFlyer: $e');
    }
  }

  // Пример метода для логирования событий
  void logEvent(String eventName, Map<String, dynamic> eventValues) {
    appsflyerSdk.logEvent(eventName, eventValues);
  }
}
