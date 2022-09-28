import 'dart:io';

import 'package:dcm/base_command.dart';

class ListCommand extends BaseCommand {
  @override
  String get description => "list all dart commands";

  @override
  String get name => "list";

  @override
  Future<void> run() async {
    await super.run();

    final configs = await readConfig();
    final listTextBuffer = StringBuffer();
    for (final config in configs) {
      listTextBuffer.write(
        """
  ${config.name}(${config.url})
    - ${config.ref} *
""",
      );
    }
    stdout.write(listTextBuffer.toString());
  }
}
