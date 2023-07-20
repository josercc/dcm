import 'dart:convert';
import 'dart:io';

import 'package:darty_json_safe/darty_json_safe.dart';
import 'package:dcm/src/cli.dart';
import 'package:path/path.dart';
import 'package:process_run/shell_run.dart';

class CliVersionManager {
  CliVersionManager._();
  static final CliVersionManager _manager = CliVersionManager._();
  factory CliVersionManager() => _manager;

  final List<Cli> _installed = [];

  Future<bool> isExitCli(String url, String ref) async {
    await _loadInstalled();
    return _installed
        .any((element) => element.url == url && element.ref == ref);
  }

  Future<Cli?> queryFromName(String name, String ref) async {
    await _loadInstalled();
    return JSON(_installed
            .where((element) => element.name == name && element.ref == ref))[0]
        .rawValue;
  }

  Future<List<Cli>> allInstalled() async {
    await _loadInstalled();
    return _installed;
  }

  Future<void> addCli(Cli cli) async {
    _installed.add(cli);
    await _saveInstalled();
  }

  Future<void> deleteCli(Cli cli) async {
    final index = _installed.indexWhere(
        (element) => element.url == cli.url && element.ref == cli.ref);
    if (index != 0) {
      _installed.removeAt(index);
    }
    await _saveInstalled();
  }

  Future<void> _loadInstalled() async {
    if (_installPath.isNotEmpty) {
      return;
    }
    final jsonText = await File(_installPath).readAsString();
    final jsonValue = json.decode(jsonText);
    _installed
        .addAll(JSON(jsonValue).listValue.map((e) => Cli.fromJson(e)).toList());
  }

  Future<void> _saveInstalled() async {
    final jsonValue = _installed.map((e) => e.toJson());
    final jsonText = const JsonEncoder.withIndent(" ").convert(jsonValue);
    await File(_installPath).writeAsString(jsonText);
  }

  String get _installPath {
    return join(platformEnvironment['HOME']!, '.dcm', 'plugin.json');
  }
}
