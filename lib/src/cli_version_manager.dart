import 'dart:convert';
import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/cli.dart';
import 'package:dcm/src/path.dart';

class CliVersionManager {
  final String? prefix;
  CliVersionManager({this.prefix});

  Future<bool> isExitCli(String url, String ref) async {
    final list = await _loadInstalled();
    return list.any((element) => element.url == url && element.ref == ref);
  }

  Future<Cli?> queryFromName(String name, String ref) async {
    final list = await _loadInstalled();
    return JSON(list.where(
      (element) => element.name == name && element.ref == ref,
    ))[0]
        .rawValue;
  }

  Future<List<Cli>> allInstalled() => _loadInstalled();

  Future<void> addCli(Cli cli) async {
    final list = await _loadInstalled();
    list.add(cli);
    await _saveInstalled(list);
  }

  Future<void> deleteCli(Cli cli) async {
    final list = await _loadInstalled();
    final index = list.indexWhere(
        (element) => element.url == cli.url && element.ref == cli.ref);
    if (index != -1) {
      list.removeAt(index);
    }
    await _saveInstalled(list);
  }

  Future<List<Cli>> _loadInstalled() async {
    final file = File(_installPath);
    if (!await file.exists()) {
      return [];
    }
    final jsonText = await File(_installPath).readAsString();
    final jsonValue = json.decode(jsonText);
    return JSON(jsonValue).listValue.map((e) => Cli.fromJson(e)).toList();
  }

  Future<void> _saveInstalled(List<Cli> clis) async {
    final jsonValue = clis.map((e) => e.toJson()).toList();
    final jsonText = const JsonEncoder.withIndent(" ").convert(jsonValue);
    final file = File(_installPath);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(jsonText);
  }

  String get _installPath => Path(prefix).configPath;
}
