import 'package:args/command_runner.dart';

class RunCommand extends Command {
  @override
  String get description => "run a dart command";

  @override
  String get name => "run";
}
