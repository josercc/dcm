import 'package:args/command_runner.dart';

class UninstallCommand extends Command {
  @override
  String get description => "uninstall a command";

  @override
  String get name => "uninstall";
}
