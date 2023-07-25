import 'dart:convert';
import 'dart:io';

import 'package:dcm/src/dart_cli_installed_model.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart';

String get homePath {
  final path = platformEnvironment["HOME"];
  if (path == null) {
    throw "\$HOME 变量不存在";
  }
  return path;
}

String get dcmPath {
  return p.join(homePath, ".dcm");
}

String get binPath => p.join(dcmPath, "bin");

String get packagesPath => p.join(dcmPath, "packages");

String packageName(Uri uri) {
  return [uri.host, ...uri.path.split("/")].join('_').replaceAll(".git", "");
}

Future<void> createDirectory(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
}

Future<List<DartCliInstalledModel>> readConfig() async {
  final file = File(configPath);
  if (!await file.exists()) {
    return [];
  }
  final configJsonText = await file.readAsString();
  final configJson = jsonDecode(configJsonText);
  if (configJson is! List) {
    return [];
  }
  return configJson
      .map((e) => DartCliInstalledModel().fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<void> saveConfig(List<DartCliInstalledModel> configs) async {
  final file = File(configPath);
  final configJson = configs.map((e) {
    return DartCliInstalledModel().toJson(e);
  }).toList();
  final configJsonText = const JsonEncoder.withIndent(" ").convert(
    configJson,
  );
  await file.writeAsString(configJsonText);
}

String get configPath => p.join(dcmPath, "config.json");

bool isLocalPath(String url) => !url.startsWith('http');

String get realmPath => p.join(dcmPath, 'dcm.realm');
