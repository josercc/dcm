import 'dart:io';
import 'package:dcm/base_command.dart';
import 'package:dcm/dart_cli_installed_model.dart';
import 'package:darty_json_safe/darty_json.dart';
import 'package:process_run/shell.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

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
      abbr: 'p',
    );
    argParser.addFlag('foce', help: "是否覆盖", abbr: 'f');
  }

  @override
  Future<void> run() async {
    await super.run();

    /// 获取 path 参数
    final path = argResults?['path'] as String? ?? '';

    /// 是否覆盖
    final foce = argResults?['foce'] as bool? ?? false;

    /// 通过 [@] 分割字符串
    final pathArguments = path.split('@');

    /// 如果分割数组不是两个元素 代表格式不正确
    if (pathArguments.length != 2) {
      throw '$path 格式不正确!';
    }

    final url = pathArguments[0];

    /// 将第一个参数解析成 Uri
    final uri = Uri.parse(url);

    /// 获取第二个参数对应的引用
    final ref = pathArguments[1];

    /// 读取目前已经安装的配置
    final configs = await readConfig();

    /// 判断安装的命令是否已经存在
    final cliExists = configs.any((element) {
      return element.name == name && ref == ref;
    });

    /// 如果存在 并且不是覆盖则提示已经安装
    if (cliExists && !foce) {
      throw "$path 已经安装! 请添加 --f 参数进行覆盖安装!";
    }

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

    final pubspecFile = File(refPath + Platform.pathSeparator + "pubspec.yaml");
    if (!await pubspecFile.exists()) {
      throw "${pubspecFile.path} 不存在";
    }
    final pubspecContent = await pubspecFile.readAsString();

    /// 读取 Pub 的名称
    final pubName = Pubspec.parse(pubspecContent).name;

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
    await Shell(workingDirectory: refPath).run(
      '''
  $dart pub get
  $dart compile exe ${mainFile.path}
''',
    );

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

    /// 如果当前的配置不存在 则保存配置
    if (!cliExists) {
      configs.add(
        DartCliInstalledModel().fromJson({})
          ..name = pubName
          ..url = url
          ..ref = ref,
      );
      await saveConfig(configs);
    }

    stdout.writeln("$pubName@$ref 安装成功");
  }
}
