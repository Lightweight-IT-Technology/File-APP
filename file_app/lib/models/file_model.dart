import 'dart:io';
class FileItem {
  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final DateTime modifiedDate;
  final String? extension;

  FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.size,
    required this.modifiedDate,
    this.extension,
  });

  factory FileItem.fromFileSystemEntity(dynamic entity) {
    return FileItem(
      name: entity.name,
      path: entity.path,
      isDirectory: entity is Directory,
      size: entity is File ? entity.lengthSync() : 0,
      modifiedDate: entity.statSync().modified,
      extension: entity is File ? entity.path.split('.').last.toLowerCase() : null,
    );
  }

  String get displaySize {
    if (isDirectory) return '文件夹';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String get displayDate {
    return '${modifiedDate.year}-${modifiedDate.month.toString().padLeft(2, '0')}-${modifiedDate.day.toString().padLeft(2, '0')}';
  }

  String get iconPath {
    if (isDirectory) return 'assets/icons/folder.png';
    
    switch (extension) {
      case 'pdf': return 'assets/icons/pdf.png';
      case 'doc':
      case 'docx': return 'assets/icons/word.png';
      case 'xls':
      case 'xlsx': return 'assets/icons/excel.png';
      case 'ppt':
      case 'pptx': return 'assets/icons/powerpoint.png';
      case 'txt': return 'assets/icons/txt.png';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp': return 'assets/icons/image.png';
      case 'mp3':
      case 'wav':
      case 'flac': return 'assets/icons/audio.png';
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov': return 'assets/icons/video.png';
      case 'zip':
      case 'rar':
      case '7z': return 'assets/icons/archive.png';
      default: return 'assets/icons/file.png';
    }
  }
}