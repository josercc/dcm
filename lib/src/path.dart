import 'dart:io';

import 'package:path/path.dart';

class Path {
  final String? prefix;
  Path([this.prefix]);

  String get homePath => Platform.environment["HOME"]!;
  String get dcmPath => join(homePath, ".dcm");
  String get rootPath {
    if (prefix == null) {
      return dcmPath;
    } else {
      return join(dcmPath, prefix);
    }
  }

  String get binPath => join(rootPath, 'bin');
  String get packagesPath => join(rootPath, 'packages');
  String get realmPath => join(rootPath, 'dcm.realm');
  String get packagePath => join(rootPath, 'plugin.json');
  String exePath(String name, String ref) =>
      join(binPath, name, ref, "$name.exe");
}
