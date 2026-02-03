
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/file_model.dart';

class FilePreview extends StatelessWidget {
  final FileItem file;

  const FilePreview({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showFileInfo(context),
            tooltip: '文件信息',
          ),
        ],
      ),
      body: _buildPreviewContent(context),
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    if (file.isDirectory) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('这是一个文件夹', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    switch (file.extension) {
      case 'txt':
        return _buildTextPreview();
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
        return _buildImagePreview();
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'xls':
      case 'xlsx':
      case 'ppt':
      case 'pptx':
        return _buildDocumentPreview();
      case 'mp3':
      case 'wav':
      case 'flac':
        return _buildAudioPreview();
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov':
        return _buildVideoPreview();
      default:
        return _buildGenericPreview();
    }
  }

  Widget _buildTextPreview() {
    return FutureBuilder<String>(
      future: _readFileContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('无法读取文件: ${snapshot.error}'));
        }
        
        final content = snapshot.data ?? '';
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            content,
            style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    return Center(
      child: Image.file(
        File(file.path),
        errorBuilder: (context, error, stackTrace) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('无法预览图片', style: TextStyle(fontSize: 16)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('文档预览功能开发中', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('支持查看文件信息', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAudioPreview() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.audiotrack, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('音频预览功能开发中', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('支持查看文件信息', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('视频预览功能开发中', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('支持查看文件信息', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGenericPreview() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('文件预览', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('支持查看文件信息', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Future<String> _readFileContent() async {
    try {
      final file = File(this.file.path);
      final content = await file.readAsString();
      return content;
    } catch (e) {
      return '无法读取文件内容: $e';
    }
  }

  void _showFileInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('文件信息'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('名称', file.name),
              _buildInfoRow('路径', file.path),
              _buildInfoRow('类型', file.isDirectory ? '文件夹' : '文件'),
              _buildInfoRow('大小', file.displaySize),
              _buildInfoRow('修改时间', file.displayDate),
              if (file.extension != null) _buildInfoRow('扩展名', file.extension!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
}