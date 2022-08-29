// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dart_cli_installed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DartCliInstalledModel _$DartCliInstalledModelFromJson(
  Map<String, dynamic> json,
) {
  return DartCliInstalledModel()
    ..url = JSON(json)["url"].stringValue
    ..ref = JSON(json)["ref"].stringValue
    ..name = JSON(json)["name"].stringValue;
}

Map<String, dynamic> _$DartCliInstalledModelToJson(
  DartCliInstalledModel instance,
) {
  return <String, dynamic>{
    'url': instance.url,
    'ref': instance.ref,
    'name': instance.name,
  };
}
