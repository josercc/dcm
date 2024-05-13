import 'dart:io';

import 'package:path/path.dart';

class Path {
  final String? prefix;
  Path([this.prefix]);

  String get homePath => Platform.environment["HOME"]!;
  String get dcmPath => join(homePath, ".dcm");
  String get binPath {
    if (prefix == null) {
      return join(dcmPath, "bin");
    } else {
      return join(dcmPath, prefix, "bin");
    }
  }

  String get packagesPath {
    if (prefix == null) {
      return join(dcmPath, "packages");
    } else {
      return join(dcmPath, prefix, "packages");
    }
  }

  String get configPath {
    if (prefix == null) {
      return join(dcmPath, "plugin.json");
    } else {
      return join(dcmPath, prefix, "plugin.json");
    }
  }

  // String get realmPath => join(dcmPath, prefix, 'dcm.realm');
  String exePath(String name, String ref) =>
      join(binPath, name, ref, "$name.exe");
}
