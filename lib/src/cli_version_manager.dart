import 'dart:io';

import 'package:dcm/src/cli.dart';
import 'package:dcm/src/dcm.dart';
import 'package:realm/realm.dart';
import 'package:realm_generate/realm_generate.dart';

class CliVersionManager {
  CliVersionManager._();
  static final CliVersionManager _manager = CliVersionManager._();
  factory CliVersionManager() => _manager;

  final RealmRunner runner = RealmRunner(
    Realm(Configuration.local([Cli.schema])),
  );

  Future<void> migrationOldConfig() async {
    final configs = await readConfig();
    for (final config in configs) {
      final results =
          runner.query<Cli>(r'url == $0 && ref == $1 && name == $2', [
        config.url,
        config.ref,
        config.name,
      ]);
      if (results.isNotEmpty) {
        continue;
      }
      runner.add(
        Cli(Uuid.v4())
          ..name = config.name
          ..ref = config.ref
          ..url = config.url
          ..isLocal = isLocalPath(config.url),
      );
    }
    if (await File(configPath).exists()) {
      await File(configPath).delete();
    }
  }

  bool isExitCli(String url, String ref) {
    return runner.query<Cli>(r'url == $0 && ref == $1', [url, ref]).isNotEmpty;
  }

  Cli? queryFromName(String name, String ref) {
    return runner.queryOne<Cli>(r'name == $0 && ref == $1', [name, ref]);
  }
}
