import 'dart:io';

import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/dcm.dart';
import 'package:dcm/src/install_mixin.dart';

class LocalInstallCommand extends BaseCommand with InstallMixin {
  @override
  String get description => '通过本地路径安装';

  @override
  String get name => 'local';

  LocalInstallCommand() {
    argParser.addOption('path', mandatory: true, abbr: 'p', help: '本地路径');
    argParser.addFlag('force', abbr: 'f', help: '是否覆盖安装!');
  }

  @override
  Future<void> run() async {
    await super.run();

    final path = argResults?['path'] as String;
    final force = argResults?['force'] as bool? ?? false;
    if (!isLocalPath(path)) {
      stderr.writeln('$path 不是一个本地路径!');
    }
    await install(path, '__local__', foce: force);
  }
}
