/// 自动生成代码 请勿修改!
/// 自动生成代码 请勿修改!
/// 自动生成代码 请勿修改!

part of 'dart_cli_installed_model.dart';

// **************************************************************************
// Create Winner App 低代码平台
// **************************************************************************

DartCliInstalledModel _$DartCliInstalledModelFromJson(
    Map<String, dynamic> json) {
  return DartCliInstalledModel()
    ..url = JSON(json)["url"].string ?? ''
    ..ref = JSON(json)["ref"].string ?? ''
    ..name = JSON(json)["name"].string ?? '';
}

Map<String, dynamic> _$DartCliInstalledModelToJson(
    DartCliInstalledModel instance) {
  return {
    'url': instance.url,
    'ref': instance.ref,
    'name': instance.name,
  };
}
