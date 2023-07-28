import 'dart:io';

import 'package:true_core/library.dart';

enum IfExistBehavior {
  addSuffix,
  override,
}

extension DirectoryExtension on Directory {
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