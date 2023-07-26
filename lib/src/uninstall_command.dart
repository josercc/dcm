import 'dart:io';

import 'package:dcm/src/base_command.dart';
import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';

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
    await uninstall(commandName, ref);
  }

  Future<void> uninstall(String commandName, String ref) async {
    final cli = await CliVersionManager().queryFromName(commandName, ref);
    if (cli == null) {
      throw "$commandName@$ref 不存在";
    }

    final binDir = join(platformEnvironment['HOME']!, '.dcm', 'bin');
    final pluginBinDir = join(binDir, commandName, ref);
    if (await Directory(pluginBinDir).exists()) {
      await Directory(pluginBinDir).delete(recursive: true);
    }

    if (await Directory(cli.installPath).exists()) {
      await Directory(cli.installPath).delete(recursive: true);
    }

    await CliVersionManager().deleteCli(cli);
    stdout.writeln("$name 卸载成功!");
  }
}
