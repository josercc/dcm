import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/generated_command.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:path/path.dart';
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
    await createProject(name, url, ref, description);
  }

  Future<void> createProject(
    String name,
    String url, [
    String? ref,
    String? description,
  ]) async {
    final mustacheData = {
      'name': name,
      'description': description ?? '$name description',
    };
    final git = await which('git');
    final workingDirectory = Directory.current.path;
    var shellCommand = "$git clone $url $name";
    if (ref != null) {
      shellCommand += " -b $ref";
    }
    print(shellCommand);
    await Shell(workingDirectory: workingDirectory).run(shellCommand);

    await GeneratedCommand().generated(
      json: mustacheData,
      rootPath: join(workingDirectory, name),
    );
  }

  String render(String template, Map<String, String> mustacheData) {
    return Template(template).renderString(mustacheData);
  }
}
