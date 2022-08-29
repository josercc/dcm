import 'dart:io';

import 'package:dcm/base_command.dart';
import 'package:darty_json_safe/darty_json.dart';

class UninstallCommand extends BaseCommand {
  @override
  String get description => "uninstall a command";

  @override
  String get name => "uninstall";

  UninstallCommand() {
    argParser.addOption(
      'name',
      help: "请输入需要写在的命令 比如 dart_cli_manager@main",
      abbr: 'n',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    await super.run();
    final name = Unwrap(argResults?['name'] as String?).defaultValue('');
    final nameArguments = name.split('@');
    if (nameArguments.length != 2) {
      throw "$name 不正确!";
    }
    final commandName = nameArguments[0];
    final ref = nameArguments[1];

    final exeFile = File(
      binPath +
          Platform.pathSeparator +
          commandName +
          Platform.pathSeparator +
          ref +
          Platform.pathSeparator +
          commandName +
          ".exe",
    );

    if (await exeFile.exists()) {
      await exeFile.delete();
    }

    final configs = await readConfig();
    final index = configs.indexWhere(
      (element) => element.name == commandName && element.ref == ref,
    );
    if (index == -1) {
      return;
    }
    configs.removeAt(index);
    await saveConfig(configs);
    stdout.write("$name 卸载成功!");
  }
}
