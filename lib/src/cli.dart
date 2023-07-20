import 'package:darty_json_safe/darty_json_safe.dart';

class Cli {
  /// 安装命令的地址
  late String url;

  /// 安装引用
  late String ref;

  /// 命令名字
  late String name;

  /// 是否本地路径安装
  late bool isLocal = false;

  /// 安装时间
  late int date;

  Cli();

  Cli.fromJson(Map<String, dynamic> map) {
    final json = JSON(map);
    url = json['url'].stringValue;
    ref = json['ref'].stringValue;
    name = json['name'].stringValue;
    isLocal = json['isLocal'].boolValue;
    date = json['date'].intValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'ref': ref,
      'name': name,
      'isLocal': isLocal,
      'date': date,
    };
  }
}
