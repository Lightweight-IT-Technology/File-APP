import 'package:flutter/material.dart';
import '../models/file_model.dart';

class WindowsFileContextMenu extends StatelessWidget {
  final FileItem file;
  final Offset position;
  final VoidCallback onDismiss;

  const WindowsFileContextMenu({
    Key? key,
    required this.file,
    required this.position,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = _buildMenuItems(context);
    
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
                children: items,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final items = <Widget>[];
    
    // 打开/运行
    items.add(_buildMenuItem(
      label: file.isDirectory ? '打开' : '打开',
      icon: Icons.open_in_new,
      onTap: () {
        onDismiss();
        // TODO: 实现打开操作
      },
    ));
    
    // 分隔线
    items.add(_buildSeparator());
    
    // 剪切
    items.add(_buildMenuItem(
      label: '剪切',
      icon: Icons.content_cut,
      onTap: () {
        onDismiss();
        // TODO: 实现剪切操作
      },
    ));
    
    // 复制
    items.add(_buildMenuItem(
      label: '复制',
      icon: Icons.content_copy,
      onTap: () {
        onDismiss();
        // TODO: 实现复制操作
      },
    ));
    
    // 粘贴 (如果有剪贴板内容)
    items.add(_buildMenuItem(
      label: '粘贴',
      icon: Icons.content_paste,
      onTap: () {
        onDismiss();
        // TODO: 实现粘贴操作
      },
    ));
    
    // 分隔线
    items.add(_buildSeparator());
    
    // 创建快捷方式
    items.add(_buildMenuItem(
      label: '创建快捷方式',
      icon: Icons.shortcut,
      onTap: () {
        onDismiss();
        // TODO: 实现创建快捷方式
      },
    ));
    
    // 删除
    items.add(_buildMenuItem(
      label: '删除',
      icon: Icons.delete,
      onTap: () {
        onDismiss();
        // TODO: 实现删除操作
      },
    ));
    
    // 重命名
    items.add(_buildMenuItem(
      label: '重命名',
      icon: Icons.edit,
      onTap: () {
        onDismiss();
        // TODO: 实现重命名操作
      },
    ));
    
    // 分隔线
    items.add(_buildSeparator());
    
    // 属性
    items.add(_buildMenuItem(
      label: '属性',
      icon: Icons.info,
      onTap: () {
        onDismiss();
        // TODO: 实现属性查看
      },
    ));
    
    return items;
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.black),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: const Color(0xFFE1E1E1),
    );
  }
}