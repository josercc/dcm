import 'dart:io';

import 'package:darty_json_safe/darty_json.dart';
import 'package:dcm/base_command.dart';
import 'package:process_run/shell.dart';

class CreateCommand extends BaseCommand {
  @override
  String get description => '创建命令行模版工程';

  @override
  String get name => 'create';

  CreateCommand() {
    argParser.addOption('name', abbr: 'n', help: '请输入命令行的名称', mandatory: true);
    argParser.addOption(
      'url',
      abbr: 'u',
      help: '模版工程 Git 仓库的 Http 地址',
      mandatory: true,
    );
    argParser.addOption('ref', abbr: 'r', help: '自定义对应引用 可以是分支 版本 或者提交');
    argParser.addOption('description', abbr: 'd', help: '请输入命令行的描述');
  }

  @override
  Future<void> run() async {
    final name = JSON(argResults?['name']).stringValue;
    final url = JSON(argResults?['url']).stringValue;
    final ref = JSON(argResults?['ref']).string;
    final description = JSON(argResults?['description']).string;
    final mustacheData = {
      'name': name,
      'description': description ?? '$name description',
    };
    final git = await which('git');
    final workingDirectory = Directory.current.path;
    await Shell(workingDirectory: workingDirectory).run(
      '''
  $git clone $url $name
''',
    );
    if (ref != null) {
      await Shell(workingDirectory: workingDirectory).run(
        '''
    cd $name;
    git switch -C $ref
''',
      );
    }
  }
}
