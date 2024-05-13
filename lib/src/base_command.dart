import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcm/dcm.dart';
import 'package:dcm/src/path.dart';

abstract class BaseCommand extends Command {
  String? prefix;

  @override
  Future<void> run() async {
    prefix = globalResults?['prefix'];

    /// 创建 $HOME/.dcm 目录
    await createDirectory(path.dcmPath);

    /// 创建 $HOME/.dcm/bin
    await createDirectory(path.binPath);

    /// 创建 $HOME/.dcm/packages
    await createDirectory(path.packagesPath);
  }

  String get packagesPath => path.packagesPath;
  String get binPath => path.binPath;

  String packageName(Uri uri) {
    return [uri.host, ...uri.path.split(Platform.pathSeparator)]
        .join('_')
        .replaceAll(".git", "");
  }

  Path get path => Path(prefix);
}
