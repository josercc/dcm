import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_cli_manager/install_command.dart';
import 'package:dart_cli_manager/list_command.dart';
import 'package:dart_cli_manager/run_command.dart';
import 'package:dart_cli_manager/uninstall_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner("dcm", "Dart Cli Version Manager")
    ..addCommand(InstallCommand())
    ..addCommand(RunCommand())
    ..addCommand(UninstallCommand())
    ..addCommand(ListCommand());
  try {
    await runner.run(args);
  } catch (e) {
    // ignore: avoid_print
    print(e.toString());
    if (e is String) {
      stdout.writeln(e);
    } else if (e is UsageException) {
      stdout.writeln(e.toString());
    }
  }
}
