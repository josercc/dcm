import 'package:realm_dart/realm.dart';
part 'cli.realm.dart';

@RealmModel()
class _Cli {
  /// 安装命令的地址
  late String url;

  /// 安装引用
  late String ref;

  /// 命令名字
  late String name;

  /// 是否本地路径安装
  bool isLocal = false;

  /// 安装时间
  late int date;

  /// 安装在本地的路径
  late String installPath;
}
