import 'dart:convert';
import 'dart:io';

import 'package:dcm/src/base_command.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class GeneratedCommand extends BaseCommand {
  @override
  String get description => '根据输入JSON和Mustache进行输出';

  @override
  String get name => 'generated';

  GeneratedCommand() {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: '输入JSON的文件路径',
      mandatory: true,
    );
    argParser.addOption(
      'path',
      abbr: 'p',
      help: '模版存放的工程路径',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final filePath = argResults?['file'];
    if (filePath is! String) {
      throw 'file 参数没有设置!';
    }
    final file = File(filePath);
    if (!await file.exists()) {
      throw '$filePath 不存在!';
    }
    final fileContent = await file.readAsString();
    final jsonValue = jsonDecode(fileContent);
    if (jsonValue is! Map<String, dynamic>) {
      throw '$filePath 必需是字典开头的 JSON 文件!';
    }
    final rootPath = argResults?['path'];
    if (rootPath is! String) {
      throw 'path 参数不存在!';
    }
    await generated(json: jsonValue, rootPath: rootPath);
  }

  Future<void> generated({
    required Map<String, dynamic> json,
    required String rootPath,
  }) async {
    final files =
        Directory(rootPath).listSync(recursive: true).whereType<File>();
    for (final file in files) {
      if (extension(file.path) != '.mustache') {
        continue;
      }
      final souceText = await file.readAsString();
      await file.delete();
      final createFile = File(withoutExtension(file.path));
      if (!createFile.existsSync()) {
        createFile.createSync(recursive: true);
      }
      await createFile.writeAsString(render(souceText, json));
    }
    stdout.writeln('❇️ 生成完毕!');
  }

  String render(String template, Map<String, dynamic> mustacheData) {
    return Template(template).renderString(mustacheData);
  }

  File _templateFile(
    String path,
    String rootPath, {
    Map<String, dynamic>? mustacheData,
  }) {
    var fullPath = path;
    if (path.startsWith('./')) {
      fullPath = rootPath + Platform.pathSeparator + path.substring(2);
    }
    if (mustacheData != null) {
      fullPath = render(fullPath, mustacheData);
    }
    return File(fullPath);
  }
}
