
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/file_model.dart';

class FileService {
  static Future<List<FileItem>> getDirectoryContents(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw Exception('目录不存在: $directoryPath');
      }

      final entities = await directory.list().toList();
      final fileItems = <FileItem>[];

      for (final entity in entities) {
        try {
          final stat = await entity.stat();
          final fileItem = FileItem(
            name: path.basename(entity.path),
            path: entity.path,
            isDirectory: entity is Directory,
            size: entity is File ? await entity.length() : 0,
            modifiedDate: stat.modified,
            extension: entity is File ? path.extension(entity.path).toLowerCase() : null,
          );
          fileItems.add(fileItem);
        } catch (e) {
          // 跳过无法访问的文件
          print('无法访问文件: ${entity.path}, 错误: $e');
        }
      }

      // 排序：目录在前，文件在后，按名称排序
      fileItems.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return fileItems;
    } catch (e) {
      throw Exception('无法读取目录内容: $e');
    }
  }

  static Future<void> createDirectory(String parentPath, String name) async {
    try {
      final newDir = Directory(path.join(parentPath, name));
      await newDir.create();
    } catch (e) {
      throw Exception('创建目录失败: $e');
    }
  }

  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      final directory = Directory(filePath);
      
      if (await file.exists()) {
        await file.delete();
      } else if (await directory.exists()) {
        await directory.delete(recursive: true);
      } else {
        throw Exception('文件或目录不存在');
      }
    } catch (e) {
      throw Exception('删除失败: $e');
    }
  }

  static Future<void> renameFile(String oldPath, String newName) async {
    try {
      final file = File(oldPath);
      final directory = Directory(oldPath);
      final newPath = path.join(path.dirname(oldPath), newName);
      
      if (await file.exists()) {
        await file.rename(newPath);
      } else if (await directory.exists()) {
        await directory.rename(newPath);
      } else {
        throw Exception('文件或目录不存在');
      }
    } catch (e) {
      throw Exception('重命名失败: $e');
    }
  }

  static Future<void> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      
      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationPath);
      } else if (await sourceDir.exists()) {
        await _copyDirectory(sourceDir, Directory(destinationPath));
      } else {
        throw Exception('源文件或目录不存在');
      }
    } catch (e) {
      throw Exception('复制失败: $e');
    }
  }

  static Future<void> moveFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      
      if (await sourceFile.exists()) {
        await sourceFile.rename(destinationPath);
      } else if (await sourceDir.exists()) {
        await sourceDir.rename(destinationPath);
      } else {
        throw Exception('源文件或目录不存在');
      }
    } catch (e) {
      throw Exception('移动失败: $e');
    }
  }

  static Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);
    
    final entities = await source.list().toList();
    
    for (final entity in entities) {
      final newPath = path.join(destination.path, path.basename(entity.path));
      
      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        await _copyDirectory(entity, Directory(newPath));
      }
    }
  }

  static Future<String> getHomeDirectory() async {
    if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'] ?? Directory.current.path;
    } else {
      return Platform.environment['HOME'] ?? Directory.current.path;
    }
  }

  static Future<List<String>> searchFiles(String directoryPath, String query) async {
    final results = <String>[];
    await _searchRecursive(Directory(directoryPath), query.toLowerCase(), results);
    return results;
  }

  static Future<void> _searchRecursive(Directory dir, String query, List<String> results) async {
    try {
      final entities = await dir.list().toList();
      
      for (final entity in entities) {
        if (entity.path.toLowerCase().contains(query)) {
          results.add(entity.path);
        }
        
        if (entity is Directory) {
          await _searchRecursive(entity, query, results);
        }
      }
    } catch (e) {
      // 跳过无法访问的目录
      print('无法搜索目录: ${dir.path}, 错误: $e');
    }
  }
}

