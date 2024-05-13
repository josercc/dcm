import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/install_mixin.dart';

import '../dcm.dart';

class ReBuildCommand extends BaseCommand with InstallMixin {
  @override
  String get name => 'rebuild';
  @override
  String get description => '重新编译';

  ReBuildCommand() {
    argParser.addOption('name', abbr: 'n', help: '请输入命令行的名称', mandatory: true);
    argParser.addOption('ref', abbr: 'r', help: '请输入命令行的版本', mandatory: true);
  }

  @override
  Future<void> run() async {
    await super.run();
    final name = JSON(argResults?['name']).stringValue;
    final ref = JSON(argResults?['ref']).stringValue;
    final cli =
        await CliVersionManager(prefix: prefix).queryFromName(name, ref);
    if (cli == null) {
      throw '命令 $name@$ref 不存在!';
    }
    await buildExe(cli.installPath, name, ref);
    stdout.writeln('重新编译成功!');
  }
}
