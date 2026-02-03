
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/file_model.dart';
import '../services/file_service.dart';

class FileProvider with ChangeNotifier {
  List<FileItem> _files = [];
  List<String> _pathHistory = [];
  int _currentPathIndex = -1;
  String _currentPath = '';
  bool _isLoading = false;
  String? _error;
  List<String> _selectedFiles = [];
  String _searchQuery = '';

  List<FileItem> get files => _files;
  String get currentPath => _currentPath;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get selectedFiles => _selectedFiles;
  String get searchQuery => _searchQuery;
  bool get canGoBack => _currentPathIndex > 0;
  bool get canGoForward => _currentPathIndex < _pathHistory.length - 1;

  FileProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _currentPath = await FileService.getHomeDirectory();
      _pathHistory.add(_currentPath);
      _currentPathIndex = 0;
      
      await _loadDirectory(_currentPath);
    } catch (e) {
      _error = '初始化失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDirectory(String path) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _files = await FileService.getDirectoryContents(path);
      _currentPath = path;
      
      // 添加到历史记录（如果不在当前索引）
      if (_currentPathIndex == -1 || _pathHistory[_currentPathIndex] != path) {
        // 清除前进历史
        if (_currentPathIndex < _pathHistory.length - 1) {
          _pathHistory = _pathHistory.sublist(0, _currentPathIndex + 1);
        }
        _pathHistory.add(path);
        _currentPathIndex = _pathHistory.length - 1;
      }
    } catch (e) {
      _error = '加载目录失败: $e';
      _files = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> navigateToDirectory(String path) async {
    await _loadDirectory(path);
  }

  Future<void> navigateUp() async {
    final parentPath = _getParentPath(_currentPath);
    if (parentPath != null) {
      await _loadDirectory(parentPath);
    }
  }

  Future<void> goBack() async {
    if (canGoBack) {
      _currentPathIndex--;
      await _loadDirectory(_pathHistory[_currentPathIndex]);
    }
  }

  Future<void> goForward() async {
    if (canGoForward) {
      _currentPathIndex++;
      await _loadDirectory(_pathHistory[_currentPathIndex]);
    }
  }

  Future<void> refresh() async {
    await _loadDirectory(_currentPath);
  }

  Future<void> createDirectory(String name) async {
    try {
      await FileService.createDirectory(_currentPath, name);
      await refresh();
    } catch (e) {
      _error = '创建目录失败: $e';
      notifyListeners();
    }
  }

  Future<void> deleteSelected() async {
    try {
      for (final filePath in _selectedFiles) {
        await FileService.deleteFile(filePath);
      }
      _selectedFiles.clear();
      await refresh();
    } catch (e) {
      _error = '删除失败: $e';
      notifyListeners();
    }
  }

  Future<void> renameFile(String oldPath, String newName) async {
    try {
      await FileService.renameFile(oldPath, newName);
      await refresh();
    } catch (e) {
      _error = '重命名失败: $e';
      notifyListeners();
    }
  }

  void selectFile(String filePath) {
    if (_selectedFiles.contains(filePath)) {
      _selectedFiles.remove(filePath);
    } else {
      _selectedFiles.add(filePath);
    }
    notifyListeners();
  }

  void selectAll() {
    if (_selectedFiles.length == _files.length) {
      _selectedFiles.clear();
    } else {
      _selectedFiles = _files.map((file) => file.path).toList();
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedFiles.clear();
    notifyListeners();
  }

  Future<void> searchFiles(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      await refresh();
    } else {
      try {
        _isLoading = true;
        notifyListeners();
        
        final results = await FileService.searchFiles(_currentPath, query);
        _files = [];
        
        for (final path in results) {
          try {
            final file = File(path);
            final stat = await file.stat();
            final fileItem = FileItem(
              name: path.split(Platform.pathSeparator).last,
              path: path,
              isDirectory: false,
              size: await file.length(),
              modifiedDate: stat.modified,
              extension: path.split('.').last.toLowerCase(),
            );
            _files.add(fileItem);
          } catch (e) {
            // 跳过无法访问的文件
          }
        }
      } catch (e) {
        _error = '搜索失败: $e';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  String? _getParentPath(String path) {
    final parent = Directory(path).parent;
    return parent.path != path ? parent.path : null;
  }
}