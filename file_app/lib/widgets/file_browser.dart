
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import '../models/file_model.dart';
import '../services/file_operations.dart';
import 'file_list_item.dart';
import 'file_preview.dart';

class FileBrowser extends StatelessWidget {
  const FileBrowser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('文件资源管理器'),
                Text(
                  fileProvider.currentPath,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: fileProvider.refresh,
                tooltip: '刷新',
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context),
                tooltip: '搜索',
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'create_folder',
                    child: Row(
                      children: [
                        Icon(Icons.create_new_folder),
                        SizedBox(width: 8),
                        Text('新建文件夹'),
                      ],
                    ),
                  ),
                  if (fileProvider.selectedFiles.isNotEmpty) ...[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('删除选中'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // 路径导航栏
              _buildPathNavigation(context),
              // 文件列表
              Expanded(
                child: _buildFileList(context),
              ),
            ],
          ),
          floatingActionButton: fileProvider.selectedFiles.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => _showActionDialog(context),
                  icon: const Icon(Icons.more_vert),
                  label: const Text('操作'),
                )
              : null,
        );
      },
    );
  }

  Widget _buildPathNavigation(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: fileProvider.canGoBack ? fileProvider.goBack : null,
            tooltip: '后退',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: fileProvider.canGoForward ? fileProvider.goForward : null,
            tooltip: '前进',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: fileProvider.navigateUp,
            tooltip: '上一级',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                fileProvider.currentPath,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    if (fileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fileProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              fileProvider.error!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fileProvider.refresh,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (fileProvider.files.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('文件夹为空', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: fileProvider.files.length,
      itemBuilder: (context, index) {
        final file = fileProvider.files[index];
        final isSelected = fileProvider.selectedFiles.contains(file.path);

        return FileListItem(
          file: file,
          isSelected: isSelected,
          onTap: () => _handleFileTap(context, file),
          onLongPress: () => fileProvider.selectFile(file.path),
          onDoubleTap: () => _handleFileDoubleTap(context, file),
        );
      },
    );
  }

  void _handleFileTap(BuildContext context, FileItem file) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    if (file.isDirectory) {
      fileProvider.navigateToDirectory(file.path);
    } else {
      fileProvider.selectFile(file.path);
    }
  }

  void _handleFileDoubleTap(BuildContext context, FileItem file) {
    if (!file.isDirectory) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FilePreview(file: file),
        ),
      );
    }
  }

  void _showSearchDialog(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    final searchController = TextEditingController(text: fileProvider.searchQuery);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索文件'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: '输入文件名或扩展名',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              fileProvider.searchFiles(searchController.text);
              Navigator.of(context).pop();
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'create_folder':
        _showCreateFolderDialog(context);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context);
        break;
    }
  }

  void _showCreateFolderDialog(BuildContext context) {
    final folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建文件夹'),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(
            hintText: '输入文件夹名称',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (folderNameController.text.isNotEmpty) {
                final fileProvider = Provider.of<FileProvider>(context, listen: false);
                fileProvider.createDirectory(folderNameController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
          '确定要删除选中的 ${fileProvider.selectedFiles.length} 个文件/文件夹吗？此操作不可撤销。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              fileProvider.deleteSelected();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('文件操作'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fileProvider.selectedFiles.length == 1) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('重命名'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showRenameDialog(context, fileProvider.selectedFiles.first);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('复制'),
              onTap: () {
                Navigator.of(context).pop();
                _copyFiles(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_cut),
              title: const Text('剪切'),
              onTap: () {
                Navigator.of(context).pop();
                _moveFiles(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, String filePath) {
    final fileNameController = TextEditingController(
      text: filePath.split(Platform.pathSeparator).last,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名'),
        content: TextField(
          controller: fileNameController,
          decoration: const InputDecoration(
            hintText: '输入新名称',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (fileNameController.text.isNotEmpty) {
                final fileProvider = Provider.of<FileProvider>(context, listen: false);
                fileProvider.renameFile(filePath, fileNameController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('重命名'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyFiles(BuildContext context) async {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    final destination = await FileOperations.selectDestinationDirectory(context, fileProvider.currentPath);
    
    if (destination != null && context.mounted) {
      try {
        await FileOperations.copyFiles(fileProvider.selectedFiles, destination);
        fileProvider.clearSelection();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已复制 ${fileProvider.selectedFiles.length} 个文件到 $destination')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('复制失败: $e')),
          );
        }
      }
    }
  }

  Future<void> _moveFiles(BuildContext context) async {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    final destination = await FileOperations.selectDestinationDirectory(context, fileProvider.currentPath);
    
    if (destination != null && context.mounted) {
      try {
        await FileOperations.moveFiles(fileProvider.selectedFiles, destination);
        fileProvider.clearSelection();
        fileProvider.refresh();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已移动 ${fileProvider.selectedFiles.length} 个文件到 $destination')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('移动失败: $e')),
          );
        }
      }
    }
  }
}