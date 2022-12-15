import 'dart:io';

import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/dcm.dart';

class PrintDBPathCommand extends BaseCommand {
  @override
  String get description => '打印数据库的路径!';

  @override
  String get name => 'print_db_path';

  @override
  Future<void> run() async {
    super.run();
    stdout.writeln(realmPath);
  }
}
