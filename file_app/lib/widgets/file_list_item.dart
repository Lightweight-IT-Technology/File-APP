
import 'package:flutter/material.dart';
import '../models/file_model.dart';

class FileListItem extends StatelessWidget {
  final FileItem file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap;

  const FileListItem({
    Key? key,
    required this.file,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isSelected ? Colors.blue.shade100 : null,
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: file.isDirectory ? Colors.blue.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              file.isDirectory ? Icons.folder : _getFileIcon(file.extension),
              color: file.isDirectory ? Colors.blue.shade600 : Colors.grey.shade600,
              size: 24,
            ),
          ),
          title: Text(
            file.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue.shade800 : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(file.displaySize),
              Text(file.displayDate, style: const TextStyle(fontSize: 12)),
            ],
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.blue)
              : const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
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