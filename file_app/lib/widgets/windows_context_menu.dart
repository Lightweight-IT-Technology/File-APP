
import 'package:flutter/material.dart';

class WindowsContextMenu extends StatelessWidget {
  final Offset position;
  final List<ContextMenuItem> items;
  final VoidCallback onDismiss;

  const WindowsContextMenu({
    Key? key,
    required this.position,
    required this.items,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景遮罩
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: Container(color: Colors.transparent),
          ),
        ),
        // 上下文菜单
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(2),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFCCCCCC)),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  return _buildMenuItem(item);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(ContextMenuItem item) {
    if (item.isSeparator) {
      return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: const Color(0xFFE1E1E1),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 16,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                item.label,
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              if (item.hasSubmenu)
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class ContextMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSeparator;
  final bool hasSubmenu;

  ContextMenuItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.isSeparator = false,
    this.hasSubmenu = false,
  });

  factory ContextMenuItem.separator() {
    return ContextMenuItem(
      label: '',
      icon: Icons.circle,
      isSeparator: true,
    );
  }
}

// 上下文菜单工具类
class ContextMenuHelper {
  static void showFileContextMenu({
    required BuildContext context,
    required Offset position,
    required VoidCallback onOpen,
    required VoidCallback onCopy,
    required VoidCallback onCut,
    required VoidCallback onDelete,
    required VoidCallback onRename,
    required VoidCallback onProperties,
  }) {
    final items = [
      ContextMenuItem(
        label: '打开',
        icon: Icons.open_in_new,
        onTap: onOpen,
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '复制',
        icon: Icons.content_copy,
        onTap: onCopy,
      ),
      ContextMenuItem(
        label: '剪切',
        icon: Icons.content_cut,
        onTap: onCut,
      ),
      ContextMenuItem(
        label: '粘贴',
        icon: Icons.content_paste,
        onTap: () {},
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '重命名',
        icon: Icons.edit,
        onTap: onRename,
      ),
      ContextMenuItem(
        label: '删除',
        icon: Icons.delete,
        onTap: onDelete,
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '属性',
        icon: Icons.info,
        onTap: onProperties,
      ),
    ];

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => WindowsContextMenu(
        position: position,
        items: items,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  static void showFolderContextMenu({
    required BuildContext context,
    required Offset position,
    required VoidCallback onOpen,
    required VoidCallback onNewFolder,
    required VoidCallback onCopy,
    required VoidCallback onCut,
    required VoidCallback onDelete,
    required VoidCallback onRename,
    required VoidCallback onProperties,
  }) {
    final items = [
      ContextMenuItem(
        label: '打开',
        icon: Icons.folder_open,
        onTap: onOpen,
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '新建文件夹',
        icon: Icons.create_new_folder,
        onTap: onNewFolder,
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '复制',
        icon: Icons.content_copy,
        onTap: onCopy,
      ),
      ContextMenuItem(
        label: '剪切',
        icon: Icons.content_cut,
        onTap: onCut,
      ),
      ContextMenuItem(
        label: '粘贴',
        icon: Icons.content_paste,
        onTap: () {},
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '重命名',
        icon: Icons.edit,
        onTap: onRename,
      ),
      ContextMenuItem(
        label: '删除',
        icon: Icons.delete,
        onTap: onDelete,
      ),
      ContextMenuItem.separator(),
      ContextMenuItem(
        label: '属性',
        icon: Icons.info,
        onTap: onProperties,
      ),
    ];

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => WindowsContextMenu(
        position: position,
        items: items,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }
}