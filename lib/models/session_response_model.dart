import 'package:json_annotation/json_annotation.dart';

part 'session_response_model.g.dart';

@JsonSerializable()
class SessionResponseModel {
  final String? sessionId;

  const SessionResponseModel(this.sessionId);

  factory SessionResponseModel.fromJson(Map<String, dynamic> json) => _$SessionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionResponseModelToJson(this);
}
