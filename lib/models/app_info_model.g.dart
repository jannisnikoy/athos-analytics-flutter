// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInfoModel _$AppInfoModelFromJson(Map<String, dynamic> json) => AppInfoModel(
      json['appName'] as String,
      json['bundleIdentifier'] as String,
      json['appVersion'] as String,
      json['appBuildNumber'] as String,
      json['platformName'] as String,
      json['platformDevice'] as String,
      json['platformVersion'] as String,
      json['platformLocale'] as String,
    );

Map<String, dynamic> _$AppInfoModelToJson(AppInfoModel instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'bundleIdentifier': instance.bundleIdentifier,
      'appVersion': instance.appVersion,
      'appBuildNumber': instance.appBuildNumber,
      'platformName': instance.platformName,
      'platformDevice': instance.platformDevice,
      'platformVersion': instance.platformVersion,
      'platformLocale': instance.platformLocale,
    };
