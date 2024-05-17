import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/dcm.dart';

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

    final cacheFile = File(Path(prefix).packagePath);
    if (await cacheFile.exists()) {
      final content = await cacheFile.readAsString();
      final clis = JSON(json.decode(content))
          .listValue
          .map((e) => Cli(
                JSON(e)['url'].stringValue,
                JSON(e)['ref'].stringValue,
                JSON(e)['name'].stringValue,
                JSON(e)['isLocal'].intValue,
                JSON(e)['installPath'].stringValue,
                isLocal: JSON(e)['isLocal'].boolValue,
              ))
          .toList();
      await CliVersionManager(prefix: prefix).addClis(clis);
      await cacheFile.delete(recursive: true);
    }
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
