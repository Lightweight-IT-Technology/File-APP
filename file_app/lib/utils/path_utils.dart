import 'dart:io';

class PathUtils {
  /// 获取用户主目录路径
  static String get userHomePath {
    if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'] ?? 'C:\\Users';
    } else {
      return Platform.environment['HOME'] ?? '/home';
    }
  }

  /// 获取桌面路径
  static String get desktopPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Desktop';
    } else {
      return '${userHomePath}/Desktop';
    }
  }

  /// 获取下载路径
  static String get downloadsPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Downloads';
    } else {
      return '${userHomePath}/Downloads';
    }
  }

  /// 获取文档路径
  static String get documentsPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Documents';
    } else {
      return '${userHomePath}/Documents';
    }
  }

  /// 获取图片路径
  static String get picturesPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Pictures';
    } else {
      return '${userHomePath}/Pictures';
    }
  }

  /// 获取音乐路径
  static String get musicPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Music';
    } else {
      return '${userHomePath}/Music';
    }
  }

  /// 获取视频路径
  static String get videosPath {
    if (Platform.isWindows) {
      return '${userHomePath}\\Videos';
    } else {
      return '${userHomePath}/Videos';
    }
  }

  /// 获取系统驱动器列表
  static List<String> getSystemDrives() {
    if (Platform.isWindows) {
      // Windows系统：获取所有驱动器
      final drives = <String>[];
      for (var driveLetter in ['C:', 'D:', 'E:', 'F:', 'G:', 'H:', 'I:', 'J:']) {
        final drivePath = '$driveLetter\\';
        if (Directory(drivePath).existsSync()) {
          drives.add(drivePath);
        }
      }
      return drives;
    } else {
      // Linux/Mac系统：返回根目录
      return ['/'];
    }
  }

  /// 检查路径是否存在
  static bool pathExists(String path) {
    try {
      return Directory(path).existsSync() || File(path).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// 获取路径的友好显示名称
  static String getDisplayName(String path) {
    if (path.endsWith('\\') || path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    
    if (path == desktopPath) return '桌面';
    if (path == downloadsPath) return '下载';
    if (path == documentsPath) return '文档';
    if (path == picturesPath) return '图片';
    if (path == musicPath) return '音乐';
    if (path == videosPath) return '视频';
    if (path == userHomePath) return '用户';
    
    // 驱动器名称
    if (path.length == 2 && path.endsWith(':')) {
      return '本地磁盘 ($path)';
    }
    
    // 返回路径的最后一部分
    final segments = path.split(Platform.pathSeparator);
    return segments.isNotEmpty ? segments.last : path;
  }
}