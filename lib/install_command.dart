import 'dart:io';

import 'package:dart_cli_manager/base_command.dart';
import 'package:darty_json_safe/darty_json.dart';
import 'package:process_run/shell.dart';

class InstallCommand extends BaseCommand {
  @override
  String get description => "install a dart command";

  @override
  String get name => "install";

  InstallCommand() {
    argParser.addOption(
      "path",
      mandatory: true,
      help: "地址加上版本号(分支，或者某个提交点) 比如 http(s)://xxxx/xxx/dart_cli_manager@main",
    );
  }

  @override
  Future<void> run() async {
    await super.run();

    /// 获取 path 参数
    final path = argResults?['path'] as String? ?? '';

    /// 通过 [@] 分割字符串
    final pathArguments = path.split('@');

    /// 如果分割数组不是两个元素 代表格式不正确
    if (pathArguments.length != 2) {
      throw '$path 格式不正确!';
    }

    /// 将第一个参数解析成 Uri
    final uri = Uri.parse(pathArguments[0]);

    /// 获取第二个参数对应的引用
    final ref = pathArguments[1];

    /// 获取当前命令的目录名称
    final packageName = this.packageName(uri);

    /// 当前目录的路径
    final packagePath = packagesPath + Platform.pathSeparator + packageName;

    await createDirectory(packagePath);

    final refPath = packagePath + Platform.pathSeparator + ref;
    final refDirectory = Directory(refPath);

    /// [refDirectory] 存在则先删除 保证每次的代码都是最新的
    if (await refDirectory.exists()) {
      await refDirectory.delete(recursive: true);
    }

    /// 将代码 clone 到 refDirectory 目录
    final git = await which("git");
    await Shell().run(
      '''
  $git clone ${uri.toString()} ${refDirectory.path}
''',
    );

    /// 获取当前本地的分支列表 为了可以修复切换分支 因为存在报错
    final branchResults = await Shell(workingDirectory: refDirectory.path).run(
      '''
  $git branch -l
''',
    );
    final refExit = branchResults.any((e) {
      return JSON(e)
          .stringValue
          .split("\n")
          .any((element) => element.contains(ref));
    });
    if (!refExit) {
      await Shell(workingDirectory: refDirectory.path).run(
        '''
  $git switch -c $ref
''',
      );
    }

    final binPath = refDirectory.path + Platform.pathSeparator + 'bin';
    if (!await Directory(binPath).exists()) {
      throw "$binPath 不存在";
    }
    final mainFile = await findMainFile(binPath);

    if (mainFile == null) {
      throw "$binPath 不存在 .dart 可执行文件!";
    }

    /// 编译 exe 执行文件
    final dart = await which('dart');
    await Shell().run(
      '''
  $dart compile exe $mainFile
''',
    );

    final exeFile = await findExeFile(binPath);
    if (exeFile == null) {
      throw "$binPath 不存在可执行的 exe";
    }
    final exeNewPath = this.binPath +
        Platform.pathSeparator +
        exeFile.path.split(Platform.pathSeparator).last;
    await exeFile.copy(exeNewPath);
  }

  Future<File?> findMainFile(String path) async {
    final list = Directory(path).listSync();
    for (final element in list) {
      if (element.path.split('.').last != 'dart') {
        continue;
      }
      if (element is! File) {
        continue;
      }
      final content = await element.readAsString();
      if (!RegExp(r'main\([\w\W]+\s+\w+\)\s+\w*\s+{').hasMatch(content)) {
        continue;
      }
      return element;
    }
    return null;
  }

  Future<File?> findExeFile(String path) async {
    final list = Directory(path).listSync();
    for (final element in list) {
      if (element.path.split('.').last != 'exe') {
        continue;
      }
      if (element is! File) {
        continue;
      }
      return element;
    }
    return null;
  }
}
