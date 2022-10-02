// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSessionModel _$CreateSessionModelFromJson(Map<String, dynamic> json) =>
    CreateSessionModel(
      json['existingSessionId'] as String?,
      AppInfoModel.fromJson(json['appInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateSessionModelToJson(CreateSessionModel instance) =>
    <String, dynamic>{
      'existingSessionId': instance.existingSessionId,
      'appInfo': instance.appInfo,
    };
