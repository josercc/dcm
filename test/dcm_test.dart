import 'package:dcm/src/create_command.dart';
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
}
