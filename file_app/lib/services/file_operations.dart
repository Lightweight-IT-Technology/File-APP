
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileOperations {
  static Future<void> copyFiles(List<String> sourcePaths, String destinationDir) async {
    for (final sourcePath in sourcePaths) {
      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      final fileName = path.basename(sourcePath);
      final destinationPath = path.join(destinationDir, fileName);

      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationPath);
      } else if (await sourceDir.exists()) {
        await _copyDirectory(sourceDir, Directory(destinationPath));
      }
    }
  }

  static Future<void> moveFiles(List<String> sourcePaths, String destinationDir) async {
    for (final sourcePath in sourcePaths) {
      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      final fileName = path.basename(sourcePath);
      final destinationPath = path.join(destinationDir, fileName);

      if (await sourceFile.exists()) {
        await sourceFile.rename(destinationPath);
      } else if (await sourceDir.exists()) {
        await sourceDir.rename(destinationPath);
      }
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

  static Future<String?> selectDestinationDirectory(BuildContext context, String currentPath) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => DestinationDialog(currentPath: currentPath),
    );
    return result;
  }
}

class DestinationDialog extends StatefulWidget {
  final String currentPath;

  const DestinationDialog({Key? key, required this.currentPath}) : super(key: key);

  @override
  State<DestinationDialog> createState() => _DestinationDialogState();
}

class _DestinationDialogState extends State<DestinationDialog> {
  String _selectedPath = '';
  List<FileSystemEntity> _directories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.currentPath;
    _loadDirectories();
  }

  Future<void> _loadDirectories() async {
    try {
      final directory = Directory(_selectedPath);
      final entities = await directory.list().toList();
      
      setState(() {
        _directories = entities.where((entity) => entity is Directory).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择目标文件夹'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            Text(_selectedPath, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _directories.length,
                      itemBuilder: (context, index) {
                        final dir = _directories[index];
                        return ListTile(
                          leading: const Icon(Icons.folder),
                          title: Text(path.basename(dir.path)),
                          onTap: () {
                            setState(() {
                              _selectedPath = dir.path;
                              _isLoading = true;
                            });
                            _loadDirectories();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedPath),
          child: const Text('选择'),
        ),
      ],
    );
  }
}