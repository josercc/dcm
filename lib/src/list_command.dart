import 'dart:io';

import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/cli.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:mustache_template/mustache.dart';

class ListCommand extends BaseCommand {
  @override
  String get description => "list all dart commands";

  @override
  String get name => "list";

  @override
  Future<void> run() async {
    await super.run();
    final allClis = CliVersionManager().runner.all<Cli>();
    final cliNames = allClis.map((e) => e.name).toSet();
    final datas = cliNames.map((e) {
      final clis = allClis.where((element) => element.name == e);
      final urls = clis.map((element) => element.url).toSet();
      return {
        'name': e,
        'urls': urls.map((e) {
          return {
            'url': e,
            'refs': clis.where((element) => element.url == e).map((e) {
              return {
                'ref': e.ref,
              };
            }).toList()
          };
        }).toList(),
      };
    }).toList();

    final content = Template('''
{{#datas}}
{{name}}
  {{#urls}}
  - {{{url}}}
    {{#refs}}
      @{{{ref}}}
    {{/refs}}
    
  {{/urls}}

{{/datas}}
''').renderString({
      'datas': datas,
    });
    stdout.writeln(content);
  }
}
