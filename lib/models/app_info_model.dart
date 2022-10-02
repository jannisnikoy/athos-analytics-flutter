import 'package:json_annotation/json_annotation.dart';

part 'app_info_model.g.dart';

@JsonSerializable()
class AppInfoModel {
  final String appName;
  final String bundleIdentifier;
  final String appVersion;
  final String appBuildNumber;
  final String platformName;
  final String platformDevice;
  final String platformVersion;
  final String platformLocale;

  const AppInfoModel(this.appName, this.bundleIdentifier, this.appVersion, this.appBuildNumber, this.platformName,
      this.platformDevice, this.platformVersion, this.platformLocale);

  factory AppInfoModel.fromJson(Map<String, dynamic> json) => _$AppInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppInfoModelToJson(this);
}
