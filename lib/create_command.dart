import 'dart:io';

import 'package:darty_json_safe/darty_json.dart';
import 'package:dcm/base_command.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

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
    var shellCommand = "$git clone $url $name";
    if (ref != null) {
      shellCommand += " -b $ref";
    }
    await Shell(workingDirectory: workingDirectory).run(shellCommand);

    final templateYamlFile =
        _File(workingDirectory + '/$name/mustache_template.yaml').file;
    if (!await templateYamlFile.exists()) {
      throw '${templateYamlFile.path} does not exist';
    }
    final yamlSource = await templateYamlFile.readAsString();
    final ymlMap = loadYaml(yamlSource);
    if (ymlMap is! YamlMap) {
      throw '${templateYamlFile.path} 格式错误!';
    }
    final templatePaths = ymlMap['mustache_template_paths'];
    if (templatePaths is! YamlList) {
      throw '${templateYamlFile.path} 不存在 mustache_template_paths 配置';
    }
    for (var i = 0; i < templatePaths.length; i++) {
      final templatePath = templatePaths[i];
      if (templatePath is! YamlMap) {
        throw 'mustache_template_paths[$i] 格式不正确!';
      }
      final source = templatePath['source'];
      final to = templatePath['to'];
      if (source is! String || to is! String) {
        throw 'source 或者 to 格式不正确!';
      }
      final sourceFile = _File(workingDirectory + '/$name/$source').file;
      final toFile =
          _File(workingDirectory + '/$name/${render(to, mustacheData)}').file;
      final souceText = await sourceFile.readAsString();
      await sourceFile.delete();
      await toFile.writeAsString(render(souceText, mustacheData));
    }
    stdout.writeln('模版工程代码生成成功!');
  }

  String render(String template, Map<String, String> mustacheData) {
    return Template(template).renderString(mustacheData);
  }
}

class _File {
  final String path;
  _File(this.path);

  File get file {
    return File(path.split('/').join(Platform.pathSeparator));
  }
}
