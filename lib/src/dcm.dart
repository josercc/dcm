import 'dart:io';

String packageName(Uri uri) {
  return [uri.host, ...uri.path.split("/")].join('_').replaceAll(".git", "");
}

Future<void> createDirectory(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
}

bool isLocalPath(String url) => !url.startsWith('http');
