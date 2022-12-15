import 'package:json_annotation/json_annotation.dart';
import 'package:darty_json_safe/darty_json_safe.dart';

part 'dart_cli_installed_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DartCliInstalledModel
    extends JsonConverter<DartCliInstalledModel, Map<String, dynamic>> {
  /// 依赖的地址
  @JsonKey(defaultValue: '', name: 'url')
  late String url;

  /// 依赖的节点
  @JsonKey(defaultValue: '', name: 'ref')
  late String ref;

  /// 命令行的名称
  @JsonKey(defaultValue: '', name: 'name')
  late String name;

  DartCliInstalledModel();

  @override
  DartCliInstalledModel fromJson(Map<String, dynamic> json) {
    return _$DartCliInstalledModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson(DartCliInstalledModel object) {
    return _$DartCliInstalledModelToJson(object);
  }
}
