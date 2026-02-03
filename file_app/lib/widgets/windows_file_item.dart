
import 'package:flutter/material.dart';
import '../models/file_model.dart';
import '../theme/windows_theme.dart';

class WindowsFileItem extends StatefulWidget {
  final FileItem file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;

  const WindowsFileItem({
    Key? key,
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<WindowsFileItem> createState() => _WindowsFileItemState();
}

class _WindowsFileItemState extends State<WindowsFileItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongPress,
        child: Container(
          height: 32,
          decoration: _getItemDecoration(),
          child: Row(
            children: [
              // 图标
              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(4),
                child: Icon(
                  _getFileIcon(widget.file.extension),
                  size: 20,
                  color: widget.file.isDirectory ? const Color(0xFF0078D4) : Colors.grey.shade700,
                ),
              ),
              // 文件名
              Expanded(
                child: Text(
                  widget.file.name,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 文件大小
              SizedBox(
                width: 80,
                child: Text(
                  widget.file.displaySize,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              // 修改日期
              SizedBox(
                width: 100,
                child: Text(
                  widget.file.displayDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getItemDecoration() {
    if (widget.isSelected) {
      return WindowsTheme.selectedItemDecoration;
    } else if (_isHovered) {
      return WindowsTheme.hoverItemDecoration;
    }
    return const BoxDecoration();
  }

  IconData _getFileIcon(String? extension) {
    if (widget.file.isDirectory) {
      return Icons.folder;
    }
    
    switch (extension) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'doc':
      case 'docx': return Icons.description;
      case 'xls':
      case 'xlsx': return Icons.table_chart;
      case 'ppt':
      case 'pptx': return Icons.slideshow;
      case 'txt': return Icons.text_fields;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp': return Icons.image;
      case 'mp3':
      case 'wav':
      case 'flac': return Icons.audiotrack;
      case 'mp4':
      case 'avi':
      case 'mkv':
      case 'mov': return Icons.videocam;
      case 'zip':
      case 'rar':
      case '7z': return Icons.archive;
      default: return Icons.insert_drive_file;
    }
  }
}