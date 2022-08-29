import 'package:args/command_runner.dart';

class ListCommand extends Command {
  @override
  String get description => "list all dart commands";

  @override
  String get name => "list";
}
