import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:process_run/shell.dart';

abstract class BaseCommand extends Command {
  @override
  Future<void> run() async {
    /// 创建 $HOME/.dcm 目录
    await createDirectory(dcmPath);

    /// 创建 $HOME/.dcm/bin
    await createDirectory(binPath);

    /// 创建 $HOME/.dcm/packages
    await createDirectory(packagesPath);
  }

  String get homePath {
    final path = platformEnvironment["HOME"];
    if (path == null) {
      throw "\$HOME 变量不存在";
    }
    return path;
  }

  String get dcmPath {
    return homePath + Platform.pathSeparator + ".dcm";
  }

  String get binPath => dcmPath + Platform.pathSeparator + "bin";

  String get packagesPath => dcmPath + Platform.pathSeparator + "packages";

  String packageName(Uri uri) {
    return [uri.host, ...uri.path.split("/")].join('_').replaceAll(".git", "");
  }

  Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create();
    }
  }
}
