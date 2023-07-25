import 'package:dcm/src/create_command.dart';
import 'package:dcm/src/list_command.dart';
import 'package:dcm/src/local_install_command.dart';
import 'package:test/test.dart';

void main() {
  test(
    'test create project',
    () async {
      await CreateCommand().createProject(
        'test_project',
        '/Users/king/Documents/plugin_template',
        'fix_runtime',
      );
    },
    timeout: Timeout.none,
  );

  test(
    'test install command',
    () async {
      await LocalInstallCommand().localInstall(
        '/Users/king/Documents/ide_plugins/fix_analyzer_runtime',
        true,
      );
    },
    timeout: Timeout.none,
  );

  test(
    'test list json',
    () async {
      await ListCommand().showListData(true);
    },
    timeout: Timeout.none,
  );
}
