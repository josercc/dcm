import 'dart:io';
import 'package:dcm/base_command.dart';
import 'package:darty_json_safe/darty_json.dart';
import 'package:process_run/shell.dart';

class RunCommand extends BaseCommand {
  @override
  String get description => "run a dart command";

  @override
  String get name => "run";

  RunCommand() {
    argParser.addOption(
      'name',
      mandatory: true,
      help: "请输入命令名字@版本 比如 dart_cli_manager@main",
      abbr: 'n',
    );

    argParser.addOption('command', mandatory: true, help: "子命令", abbr: 'c');
  }

  @override
  Future<void> run() async {
    await super.run();
    final name = Unwrap(argResults?['name'] as String?).defaultValue('');
    final command = Unwrap(argResults?['command'] as String?).defaultValue('');
    final nameArguments = name.split("@");
    if (nameArguments.length != 2) {
      throw "$name 参数不正确，中间需要@分割!";
    }
    final commandName = nameArguments[0];
    final ref = nameArguments[1];
    final exePath = binPath +
        Platform.pathSeparator +
        commandName +
        Platform.pathSeparator +
        ref +
        Platform.pathSeparator +
        commandName +
        ".exe";
    final exeFile = File(exePath);
    if (!await exeFile.exists()) {
      throw "$name 命令不存在请先进行安装!";
    }
    await Shell().run(
      """
  $exePath $command
""",
    );
  }
}
