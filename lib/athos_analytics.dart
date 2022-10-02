library athos_analytics;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'models/app_info_model.dart';
import 'models/create_session_model.dart';
import 'models/session_response_model.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';

class AthosKeys {
  static const String sessionId = 'nl.mobles.athos.sessionId';
  static const String userId = 'nl.mobles.athos.userId';
}

class AthosConfiguration {
  final String apiKey;
  final String baseUrl;

  const AthosConfiguration({required this.apiKey, this.baseUrl = 'api.athos-analytics.io'});
}

class AthosAnalytics {
  static AthosAnalytics instance = AthosAnalytics();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Client _httpClient = Client();

  AthosConfiguration? _configuration;
  String? _sessionId;
  String? _userId;
  AppInfoModel? _appInfo;

  Future<void> initializeApp(AthosConfiguration configuration) async {
    if (_sessionId != null) {
      log('[ATHOS] Library already initialized.');
      return;
    }

    _configuration = configuration;

    final String? existingSessionId = await _storage.read(key: AthosKeys.sessionId);

    if (existingSessionId != null) {
      _sessionId = existingSessionId;
    }

    _userId = await _storage.read(key: AthosKeys.userId);

    _appInfo = await _getAppInfo();
    final response = await _httpClient.put(Uri.https(_configuration!.baseUrl, '/v1/session'),
        headers: _getHeaders(), body: jsonEncode(CreateSessionModel(existingSessionId, _appInfo!)));

    _sessionId = SessionResponseModel.fromJson(jsonDecode(response.body)['content']).sessionId;

    await _storage.write(key: AthosKeys.sessionId, value: _sessionId);

    logEvent('app_started');
  }

  void setUserId(String? userId) async {
    if (userId == null) {
      await _storage.delete(key: AthosKeys.userId);
    } else {
      await _storage.write(key: AthosKeys.userId, value: userId);
    }
  }

  void logButtonPress(String buttonName, {Map<String, String>? payload}) {
    Map<String, String> eventPayload = {'button_name': buttonName};

    if (payload != null) {
      eventPayload.addAll(payload);
    }

    logEvent('button_pressed', payload: eventPayload);
  }

  void logScreenView(String screenName, {Map<String, String>? payload}) {
    Map<String, String> eventPayload = {'screen_name': screenName};

    if (payload != null) {
      eventPayload.addAll(payload);
    }

    logEvent('screen_view', payload: eventPayload);
  }

  void logEvent(String event, {Map<String, String>? payload}) {
    if (_configuration == null || _sessionId == null) {
      log('[ATHOS] Library not initialized. Call initializeApp();');
      return;
    }

    Map<String, String> eventPayload = {'event_name': event};
    if (payload != null) {
      eventPayload.addAll({'payload': jsonEncode(payload)});
    }

    _httpClient.put(Uri.https(_configuration!.baseUrl, '/v1/event'),
        headers: _getHeaders(), body: jsonEncode(eventPayload));
  }

  void reset() {
    if (_configuration == null) {
      log('[ATHOS] Library not initialized.');
      return;
    }

    _storage.delete(key: AthosKeys.sessionId);
    _storage.delete(key: AthosKeys.userId);

    _sessionId = null;
    _userId = null;

    initializeApp(_configuration!);
  }

  Future<AppInfoModel> _getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    String platformName = Platform.operatingSystem;
    String platformDevice = Platform.operatingSystem;
    String platformVersion = Platform.operatingSystemVersion;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      platformDevice = deviceInfo.device;
      platformVersion = deviceInfo.version.release;
    } else if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      platformDevice = deviceInfo.model;
      platformVersion = deviceInfo.systemVersion;
    }

    return AppInfoModel(info.appName, info.packageName, info.version, info.buildNumber, platformName, platformDevice,
        platformVersion, Platform.localeName);
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Athos-Api-Key': _configuration!.apiKey,
      'X-Athos-Debug-Mode': kDebugMode.toString()
    };

    if (_sessionId != null) {
      headers.addAll({'X-Athos-Session-Id': _sessionId!});
    }

    if (_userId != null) {
      headers.addAll({'X-Athos-User-Id': _userId!});
    }

    if (_appInfo != null) {
      headers.addAll({
        'User-Agent':
            'AthosAnalytics/1.0 (${_appInfo!.platformName}; ${_appInfo!.platformVersion}; ${_appInfo!.platformLocale}) ${_appInfo!.appName}/${_appInfo!.appVersion} (${_appInfo!.appBuildNumber})'
      });
    }

    return headers;
  }
}
