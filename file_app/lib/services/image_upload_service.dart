import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// 图片上传服务 - 处理用户上传背景图片
class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  
  factory ImageUploadService() {
    return _instance;
  }
  
  ImageUploadService._internal();
  
  /// 支持的图片格式
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'
  ];
  
  /// 最大文件大小 (10MB)
  static const int maxFileSize = 10 * 1024 * 1024;
  
  /// 选择图片文件
  Future<String?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: supportedImageFormats,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // 检查文件大小
        if (file.size > maxFileSize) {
          throw Exception('文件大小超过限制 (最大10MB)');
        }
        
        // 检查文件格式
        final extension = path.extension(file.name ?? '').toLowerCase();
        if (!_isSupportedImageFormat(extension)) {
          throw Exception('不支持的图片格式');
        }
        
        return file.path;
      }
    } catch (e) {
      print('选择图片失败: $e');
      rethrow;
    }
    
    return null;
  }
  
  /// 复制图片到应用目录
  Future<String> copyImageToAppDirectory(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      
      // 获取应用文档目录
      final appDir = await getApplicationDocumentsDirectory();
      final backgroundDir = Directory(path.join(appDir.path, 'backgrounds'));
      
      // 创建背景图片目录
      if (!await backgroundDir.exists()) {
        await backgroundDir.create(recursive: true);
      }
      
      // 生成唯一文件名
      final fileName = 'background_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
      final destinationPath = path.join(backgroundDir.path, fileName);
      
      // 复制文件
      await sourceFile.copy(destinationPath);
      
      return destinationPath;
    } catch (e) {
      print('复制图片失败: $e');
      rethrow;
    }
  }
  
  /// 删除背景图片
  Future<void> deleteBackgroundImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('删除图片失败: $e');
    }
  }
  
  /// 获取所有已上传的背景图片
  Future<List<String>> getUploadedBackgrounds() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backgroundDir = Directory(path.join(appDir.path, 'backgrounds'));
      
      if (!await backgroundDir.exists()) {
        return [];
      }
      
      final files = await backgroundDir.list().toList();
      final imagePaths = <String>[];
      
      for (final file in files) {
        if (file is File) {
          final extension = path.extension(file.path).toLowerCase();
          if (_isSupportedImageFormat(extension)) {
            imagePaths.add(file.path);
          }
        }
      }
      
      return imagePaths;
    } catch (e) {
      print('获取已上传背景失败: $e');
      return [];
    }
  }
  
  /// 检查是否为支持的图片格式
  bool _isSupportedImageFormat(String extension) {
    final formats = supportedImageFormats.map((f) => '.$f').toList();
    return formats.contains(extension.toLowerCase());
  }
  
  /// 获取图片文件大小
  Future<String> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      final size = await file.length();
      
      if (size < 1024) {
        return '${size}B';
      } else if (size < 1024 * 1024) {
        return '${(size / 1024).toStringAsFixed(1)}KB';
      } else {
        return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
      }
    } catch (e) {
      return '未知大小';
    }
  }
  
  /// 验证图片文件
  Future<bool> validateImage(String filePath) async {
    try {
      final file = File(filePath);
      
      // 检查文件是否存在
      if (!await file.exists()) {
        return false;
      }
      
      // 检查文件大小
      final size = await file.length();
      if (size > maxFileSize) {
        return false;
      }
      
      // 检查文件格式
      final extension = path.extension(filePath).toLowerCase();
      if (!_isSupportedImageFormat(extension)) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// 图片预览组件
class ImagePreviewWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  
  const ImagePreviewWidget({
    Key? key,
    required this.imagePath,
    this.width = 100,
    this.height = 100,
    this.onTap,
    this.showDeleteButton = false,
    this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imagePath),
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          if (showDeleteButton)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 图片上传按钮组件
class ImageUploadButton extends StatelessWidget {
  final Function(String) onImageSelected;
  final String buttonText;
  final double buttonWidth;
  
  const ImageUploadButton({
    Key? key,
    required this.onImageSelected,
    this.buttonText = '选择图片',
    this.buttonWidth = 120,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton.icon(
        onPressed: () => _pickImage(context),
        icon: const Icon(Icons.photo_library, size: 16),
        label: Text(buttonText, style: const TextStyle(fontSize: 12)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
  
  Future<void> _pickImage(BuildContext context) async {
    try {
      final imageUploadService = ImageUploadService();
      final imagePath = await imageUploadService.pickImage();
      
      if (imagePath != null) {
        // 验证图片
        final isValid = await imageUploadService.validateImage(imagePath);
        
        if (isValid) {
          // 复制到应用目录
          final copiedPath = await imageUploadService.copyImageToAppDirectory(imagePath);
          onImageSelected(copiedPath);
        } else {
          _showErrorSnackBar(context, '图片文件无效或格式不支持');
        }
      }
    } catch (e) {
      _showErrorSnackBar(context, '选择图片失败: ${e.toString()}');
    }
  }
  
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}