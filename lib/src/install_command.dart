import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:dcm/src/install_mixin.dart';

class InstallCommand extends BaseCommand with InstallMixin {
  @override
  String get description => "install a dart command";

  @override
  String get name => "install";

  InstallCommand() {
    argParser.addOption(
      "path",
      mandatory: true,
      help: "地址加上版本号(分支，或者某个提交点) 比如 http(s)://xxxx/xxx/dart_cli_manager@main",
      abbr: 'p',
    );
    argParser.addFlag('foce', help: "是否覆盖", abbr: 'f');
  }

  @override
  Future<void> run() async {
    await super.run();

    /// 获取 path 参数
    final path = argResults?['path'] as String? ?? '';

    /// 是否覆盖
    final foce = argResults?['foce'] as bool? ?? false;

    /// 通过 [@] 分割字符串
    final pathArguments = path.split('@');

    /// 如果分割数组不是两个元素 代表格式不正确
    if (pathArguments.length != 2) {
      throw '$path 格式不正确!';
    }

    final url = pathArguments[0];

    /// 获取第二个参数对应的引用
    final ref = pathArguments[1];

    final urlInstalled = CliVersionManager().isExitCli(url, ref);
    if (urlInstalled && !foce) {
      throw "$url@$ref 已经安装! 请添加 --f 参数进行覆盖安装!";
    }
    await install(url, ref, foce: foce);
  }
}
