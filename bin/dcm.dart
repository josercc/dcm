import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcm/create_command.dart';
import 'package:dcm/install_command.dart';
import 'package:dcm/list_command.dart';
import 'package:dcm/run_command.dart';
import 'package:dcm/uninstall_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner("dcm", "Dart Cli Version Manager")
    ..addCommand(InstallCommand())
    ..addCommand(RunCommand())
    ..addCommand(UninstallCommand())
    ..addCommand(ListCommand())
    ..addCommand(CreateCommand());
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
