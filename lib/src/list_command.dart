import 'dart:convert';
import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:mustache_template/mustache.dart';

class ListCommand extends BaseCommand {
  ListCommand() {
    argParser.addFlag('json', abbr: 'j', help: '是否输出json格式');
  }

  @override
  String get description => "list all dart commands";

  @override
  String get name => "list";

  @override
  Future<void> run() async {
    await super.run();
    final json = JSON(argResults?['json']).boolValue;
    await showListData(json);
  }

  Future<void> showListData(bool json) async {
    final allClis = await CliVersionManager(prefix: prefix).allInstalled();
    if (json) {
      final jsonText = const JsonEncoder.withIndent(" ").convert(allClis
          .map((e) => {
                'name': e.name,
                'url': e.url,
                'ref': e.ref,
                'isLocal': e.isLocal,
                'date': e.date,
                'installPath': e.installPath,
              })
          .toList());
      stdout.writeln(jsonText);
      return;
    }
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
