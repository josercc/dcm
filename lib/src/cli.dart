import 'package:realm/realm.dart';
import 'package:realm_generate/realm_generate.dart';

part 'cli.g.dart';
part 'cli.m.dart';

@RealmModel()
class _Cli {
  @PrimaryKey()
  late Uuid id;

  /// 安装命令的地址
  String url = '';

  /// 安装引用
  String ref = '';

  /// 命令名字
  String name = '';

  /// 是否本地路径安装
  bool isLocal = false;

  /// 安装时间
  DateTime? date;
}
