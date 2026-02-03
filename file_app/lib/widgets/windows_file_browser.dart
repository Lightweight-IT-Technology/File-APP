
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import '../models/file_model.dart';
import '../services/file_operations.dart';
import '../theme/windows_theme.dart';
import 'windows_toolbar.dart';
import 'windows_file_item.dart';
import 'windows_context_menu.dart';
import 'file_preview.dart';

class WindowsFileBrowser extends StatelessWidget {
  const WindowsFileBrowser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(
      builder: (context, fileProvider, child) {
        return Scaffold(
          backgroundColor: WindowsTheme.lightTheme.scaffoldBackgroundColor,
          body: Column(
            children: [
              // Windows风格工具栏
              const WindowsToolbar(),
              // 文件列表标题栏
              _buildListHeader(),
              // 文件列表
              Expanded(
                child: _buildFileList(context),
              ),
              // 状态栏
              _buildStatusBar(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListHeader() {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE1E1E1)),
        ),
      ),
      child: Row(
        children: [
          // 名称列
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                '名称',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          // 大小列
          SizedBox(
            width: 80,
            child: Text(
              '大小',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          // 修改日期列
          SizedBox(
            width: 100,
            child: Text(
              '修改日期',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildFileList(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    if (fileProvider.isLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (fileProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              fileProvider.error!,
              style: const TextStyle(fontSize: 14, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fileProvider.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0078D4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (fileProvider.files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('文件夹为空', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _showCreateFolderDialog(context),
              child: const Text('新建文件夹'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: fileProvider.files.length,
      itemBuilder: (context, index) {
        final file = fileProvider.files[index];
        final isSelected = fileProvider.selectedFiles.contains(file.path);

        return WindowsFileItem(
          file: file,
          isSelected: isSelected,
          onTap: () => _handleFileTap(context, file),
          onDoubleTap: () => _handleFileDoubleTap(context, file),
          onLongPress: () => _showContextMenu(context, file),
        );
      },
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        border: const Border(
          top: BorderSide(color: Color(0xFFE1E1E1)),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            '${fileProvider.selectedFiles.length} 个选定项目',
            style: const TextStyle(fontSize: 11),
          ),
          const Spacer(),
          Text(
            '${fileProvider.files.length} 个项目',
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    if (file.isDirectory) {
      fileProvider.navigateToDirectory(file.path);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FilePreview(file: file),
        ),
      );
    }
  }

  void _showContextMenu(BuildContext context, FileItem file) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    if (file.isDirectory) {
      ContextMenuHelper.showFolderContextMenu(
        context: context,
        position: position,
        onOpen: () {
          Navigator.of(context).pop();
          fileProvider.navigateToDirectory(file.path);
        },
        onNewFolder: () {
          Navigator.of(context).pop();
          _showCreateFolderDialog(context);
        },
        onCopy: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _copyFiles(context);
        },
        onCut: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _moveFiles(context);
        },
        onDelete: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _showDeleteConfirmationDialog(context);
        },
        onRename: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _showRenameDialog(context, file.path);
        },
        onProperties: () {
          Navigator.of(context).pop();
          _showFileProperties(context, file);
        },
      );
    } else {
      ContextMenuHelper.showFileContextMenu(
        context: context,
        position: position,
        onOpen: () {
          Navigator.of(context).pop();
          _handleFileDoubleTap(context, file);
        },
        onCopy: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _copyFiles(context);
        },
        onCut: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _moveFiles(context);
        },
        onDelete: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _showDeleteConfirmationDialog(context);
        },
        onRename: () {
          Navigator.of(context).pop();
          fileProvider.selectFile(file.path);
          _showRenameDialog(context, file.path);
        },
        onProperties: () {
          Navigator.of(context).pop();
          _showFileProperties(context, file);
        },
      );
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

  void _showFileProperties(BuildContext context, FileItem file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${file.name} 属性'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertyRow('名称', file.name),
              _buildPropertyRow('路径', file.path),
              _buildPropertyRow('类型', file.isDirectory ? '文件夹' : '文件'),
              _buildPropertyRow('大小', file.displaySize),
              _buildPropertyRow('修改日期', file.displayDate),
              if (file.extension != null) _buildPropertyRow('扩展名', file.extension!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
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