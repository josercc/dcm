import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/dcm.dart';
import 'package:dcm/src/install_mixin.dart';
import 'package:process_run/shell.dart';

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
    await localInstall(path, force);
  }

  Future<void> localInstall(String path, bool force) async {
    if (path.startsWith('./')) {
      path = path.replaceFirst('./', '');
    }
    path = Uri.file(Directory.current.path).resolve(path).toFilePath();
    if (!isLocalPath(path)) {
      stderr.writeln('$path 不是一个本地路径!');
    }
    final git = await which('git');
    final branch = await Shell(workingDirectory: path)
        .run('''$git branch --show-current''').then((value) {
      return JSON(value)[0]
          .unwrap<ProcessResult>()
          .map((e) => e.stdout?.toString())
          .value;
    });
    await install(
      path,
      Unwrap(branch)
          .map((e) => e.replaceAll('\n', ''))
          .defaultValue('__local__'),
      foce: force,
    );
  }
}
