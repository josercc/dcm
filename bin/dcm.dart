import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:dcm/src/create_command.dart';
import 'package:dcm/src/generated_command.dart';
import 'package:dcm/src/install_command.dart';
import 'package:dcm/src/list_command.dart';
import 'package:dcm/src/local_install_command.dart';
import 'package:dcm/src/print_db_path_command.dart';
import 'package:dcm/src/run_command.dart';
import 'package:dcm/src/uninstall_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner("dcm", "Dart Cli Version Manager")
    ..addCommand(InstallCommand())
    ..addCommand(RunCommand())
    ..addCommand(UninstallCommand())
    ..addCommand(ListCommand())
    ..addCommand(CreateCommand())
    ..addCommand(GeneratedCommand())
    ..addCommand(LocalInstallCommand())
    ..addCommand(PrintDBPathCommand());

  var sourceArgs = args;
  if (!sourceArgs.contains('-c') &&
      !sourceArgs.contains('--command') &&
      sourceArgs.isNotEmpty &&
      sourceArgs.first == 'run') {
    if (sourceArgs.length > 3) {
      final subCommond = sourceArgs.sublist(3).join(" ");
      sourceArgs = sourceArgs.sublist(0, 3);
      sourceArgs.addAll(['-c', subCommond]);
    }
  }
  try {
    await runner.run(sourceArgs);
    exit(0);
  } catch (e) {
    stdout.writeln(e.toString());
    exit(-1);
  }
}
