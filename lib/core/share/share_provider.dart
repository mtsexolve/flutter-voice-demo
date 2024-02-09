import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../constants/strings_mts.dart';

class ShareProvider {

  static final ShareProvider _instance = ShareProvider._initial();
  factory ShareProvider() {
    return _instance;
  }

  ShareProvider._initial();

  Directory? _docDir;
  Directory? _tempDir;


  Future<String> share(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    _docDir ??= await getApplicationDocumentsDirectory();
    _tempDir ??= await getTemporaryDirectory();

    cleanup();
    copyFiles();
    var files = getFiles();
    String str = '';
    for (var file in files) {
      str += "${file.name}\n";
    }

    if (files.isEmpty) {
      return StringsMts.shareNoFiles;
    }

    await Share.shareXFiles(files,
        subject: "Log files",
        text: "$str\n${files.length} file(s) total",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    cleanup();
    return 'Operation finished\n${files.length} file(s)';
  }

  Directory getDstDir() {
    return Directory('${_tempDir?.path}/temp');
  }

  copyFiles() {
    final srcDir = Directory(Platform.isAndroid
            ? '${_docDir?.parent.path}/files/logs'
            : '${_docDir?.path}');
    final dir = getDstDir();
    dir.createSync();
    for (var entry in srcDir.listSync(recursive: false, followLinks: false)) {
      if (entry.statSync().type == FileSystemEntityType.file) {
        var name = entry.uri.pathSegments.last.toString();
        if (name.startsWith('sdk') || name.startsWith('voip')) {
          File(entry.path).copySync('${dir.path}/$name');
        }
      }
    }
  }

  cleanup() {
    final dir = getDstDir();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  List<XFile> getFiles() {
     var files = getDstDir()
       .listSync(recursive: false, followLinks: false)
       .map((entry) => XFile(entry.path)).toList();
     files.sort((a, b) => a.path.compareTo(b.path));
     return files;
  }

}
