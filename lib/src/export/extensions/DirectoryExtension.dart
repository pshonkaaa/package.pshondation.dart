import 'dart:io';

import 'package:pshondation/library.dart';

enum IfExistBehavior {
  addSuffix,
  override,
}

extension DirectoryExtension on Directory {
  Future<File> createTempFile([
    String prefix = '',
    String suffix = '',
  ]) async {
    File tmpFile;

    for(int i = DateTime.now().millisecondsSinceEpoch; true; i++) {
      tmpFile = File(path + Platform.pathSeparator + prefix + i.toRadixString(16).padLeft(16, '0') + suffix);
      if(await tmpFile.exists())
        continue;
      break;
    } await tmpFile.create(recursive: true);
    
    return tmpFile;
  }

  Future<bool> contains(
    String subPath,
  ) async {
    try {
      final type = await FileSystemEntity.type(path + Platform.pathSeparator + subPath);
      return type != FileSystemEntityType.notFound;
    } on PathNotFoundException {
      return false;
    }
  }

  /// TODO could be better, if use native dir.list
  Future<bool> containsList(
    List<String> subPaths,
  ) async {
    final futures = subPaths.map((e) => contains(e)).toList();
    return !(await Future.wait(futures)).contains(false);
  }

  Future<Directory> copy(
    String path, {
      bool recursive = false,
      bool followLinks = true,
      IfExistBehavior behavior = IfExistBehavior.addSuffix, 
  }) async {
    final src = this;
    final dst = Directory(path);
    await dst.create(recursive: true);

    final entities = await src.list(
      recursive: recursive,
      followLinks: followLinks,
    ).asFuture();

    for(final entity in entities) {
      final subPath = entity.path.replaceFirst(src.path + Platform.pathSeparator, '');
      final newPath = dst.path + Platform.pathSeparator + subPath;
      
      if(entity is File) {
        final dstFile = await _createFileByBehavior(newPath, behavior);
        
        await entity.copy(dstFile.path);

      } else if(entity is Directory) {
        final dstDir = Directory(newPath);
        await dstDir.create(recursive: true);

      } else throw 'Unknown entity type: ${entity.runtimeType}';
    } return dst;
  }

  Future<File> _createFileByBehavior(String path, IfExistBehavior behavior) async {
    File file = File(path);

    switch(behavior) {
      case IfExistBehavior.addSuffix:
        for(int i = 2; true; i++) {
          try {
            await file.create(recursive: true, exclusive: true);
          } on PathExistsException {
            file = File(path + ' ($i)');
            continue;
          } break;
        }
        break;

      case IfExistBehavior.override:
        try {
          await file.create(recursive: true, exclusive: true);
        } on PathExistsException {
          await file.delete();
        }
        break;
    }

    return file;
  }
}