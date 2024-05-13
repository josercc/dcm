import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/base_command.dart';
import 'package:dcm/src/cli_version_manager.dart';
import 'package:path/path.dart';
import 'package:process_run/shell_run.dart';

class GetAllBranchCommand extends BaseCommand {
  @override
  String get description => '获取安装命令下面的所有支持分支';

  @override
  String get name => 'get_all_branch';

  GetAllBranchCommand() {
    argParser.addOption('name', abbr: 'n', help: '请输入命令名称', mandatory: true);
    argParser.addOption('ref', abbr: 'r', help: '请输入命令版本', mandatory: true);
  }

  @override
  Future<void> run() async {
    final name = JSON(argResults?['name']).stringValue;
    final ref = JSON(argResults?['ref']).stringValue;

    /// 查询命令
    final cli =
        await CliVersionManager(prefix: prefix).queryFromName(name, ref);
    if (cli == null) {
      throw '命令 $name@$ref 不存在!';
    }
    final gitDir = join(cli.installPath, '.git');
    if (!await Directory(gitDir).exists()) {
      throw '${cli.installPath} 不是一个 Git 目录!';
    }
    final shellFile =
        File(join(platformEnvironment['HOME']!, '.dcm', 'get_all_branch.sh'));
    if (!await shellFile.exists()) {
      await shellFile.create(recursive: true);
    }
    await shellFile.writeAsString(_shellScript);
    try {
      final results = await Shell(
        workingDirectory: cli.installPath,
        verbose: false,
      ).run('bash ${shellFile.path} ${cli.installPath}');
      stdout.writeln(
          JSON(results)[0].unwrap<ProcessResult>().map((e) => e.stdout).value);
    } finally {
      await shellFile.delete();
    }
  }
}

const _shellScript = r'''
#!/bin/bash

cd $1
branches=$(git branch -a --format='%(refname:short)')
json="["
while read -r branch; do
    json+="\"$branch\","
done <<< "$branches"
json=${json%,}
json+="]"
echo $json
''';
