import 'package:athos_analytics/models/app_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_session_model.g.dart';

@JsonSerializable()
class CreateSessionModel {
  final String? existingSessionId;
  final AppInfoModel appInfo;

  const CreateSessionModel(this.existingSessionId, this.appInfo);

  factory CreateSessionModel.fromJson(Map<String, dynamic> json) => _$CreateSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSessionModelToJson(this);
}
