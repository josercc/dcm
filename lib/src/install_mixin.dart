import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/cli.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:dcm/src/dcm.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:realm/realm.dart';

mixin InstallMixin on BaseCommand {
  Future<void> install(String path, String ref, {bool foce = false}) async {
    final uri = Uri.parse(path);

    /// 获取当前命令的目录名称
    final packageName = this.packageName(uri);

    /// 当前目录的路径
    final packagePath = p.join(packagesPath, packageName);

    await createDirectory(packagePath);

    final refPath = p.join(packagePath, ref);
    final refDirectory = Directory(refPath);

    /// [refDirectory] 存在则先删除 保证每次的代码都是最新的
    if (await refDirectory.exists()) {
      await refDirectory.delete(recursive: true);
    }

    /// 将代码 clone 到 refDirectory 目录

    if (isLocalPath(path)) {
      await copyPath(path, refPath);
    } else {
      final git = await which("git");
      await Shell().run(
        '''
  $git clone ${uri.toString()} ${refDirectory.path}
''',
      );

      /// 获取当前本地的分支列表 为了可以修复切换分支 因为存在报错
      final branchResults =
          await Shell(workingDirectory: refDirectory.path).run(
        '''
  $git branch -l
''',
      );
      final refExit = branchResults.any((e) {
        return Unwrap(e.stdout as String?)
            .defaultValue('')
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
    }

    final pubspecFile = File(refPath + Platform.pathSeparator + "pubspec.yaml");
    if (!await pubspecFile.exists()) {
      throw "${pubspecFile.path} 不存在";
    }
    final pubspecContent = await pubspecFile.readAsString();

    /// 读取 Pub 的名称
    final pubName = Pubspec.parse(pubspecContent).name;

    final cli = CliVersionManager().runner.queryOne<Cli>(
      r'ref == $0 && name == $1',
      [ref, pubName],
    );

    /// 判断安装的命令是否已经存在
    final cliExists = cli != null;

    /// 如果存在 并且不是覆盖则提示已经安装
    if (cliExists && !foce) {
      throw "$pubName@$ref 已经安装! 请添加 --f 参数进行覆盖安装!";
    }

    final binPath = refDirectory.path + Platform.pathSeparator + 'bin';
    if (!await Directory(binPath).exists()) {
      throw "$binPath 不存在";
    }
    final mainFile = File(binPath + Platform.pathSeparator + "$pubName.dart");

    if (!await mainFile.exists()) {
      throw "${mainFile.path} 不存在";
    }

    /// 编译 exe 执行文件
    final dart = await which('dart');
    final fvm = await which('fvm');
    if (!await File(p.join(refPath, '.fvm', 'fvm_config.json')).exists()) {
      await Shell(workingDirectory: refPath).run(
        '''
  $fvm dart pub get
  $fvm dart compile exe ${mainFile.path}
''',
      );
    } else {
      await Shell(workingDirectory: refPath).run(
        '''
  $dart pub get
  $dart compile exe ${mainFile.path}
''',
      );
    }

    final exeFile = File(binPath + Platform.pathSeparator + "$pubName.exe");
    if (!await exeFile.exists()) {
      throw "${exeFile.path} 不存在";
    }

    final copyToDirectory = Directory(
      this.binPath +
          Platform.pathSeparator +
          pubName +
          Platform.pathSeparator +
          ref,
    );

    if (!await copyToDirectory.exists()) {
      await copyToDirectory.create(recursive: true);
    }

    final exeNewPath =
        copyToDirectory.path + Platform.pathSeparator + "$pubName.exe";
    await exeFile.copy(exeNewPath);

    if (cli == null) {
      CliVersionManager().runner.add(
            Cli(Uuid.v4())
              ..name = pubName
              ..url = path
              ..ref = ref
              ..isLocal = isLocalPath(path)
              ..date = DateTime.now(),
          );
    }

    stdout.writeln("$pubName@$ref 安装成功");
  }
}
