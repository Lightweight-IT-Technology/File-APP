
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import '../theme/windows_theme.dart';

class WindowsToolbar extends StatelessWidget {
  const WindowsToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: WindowsTheme.toolbarDecoration,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          // 导航按钮
          _buildNavigationButtons(context),
          VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.3)),
          // 路径显示
          _buildPathDisplay(context),
          const Spacer(),
          // 搜索框
          _buildSearchBox(context),
          const SizedBox(width: 12),
          // 视图切换
          _buildViewButtons(context),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    
    return Row(
      children: [
        _buildToolbarButton(
          icon: Icons.arrow_back,
          tooltip: '后退',
          enabled: fileProvider.canGoBack,
          onPressed: fileProvider.canGoBack ? fileProvider.goBack : null,
        ),
        _buildToolbarButton(
          icon: Icons.arrow_forward,
          tooltip: '前进',
          enabled: fileProvider.canGoForward,
          onPressed: fileProvider.canGoForward ? fileProvider.goForward : null,
        ),
        _buildToolbarButton(
          icon: Icons.arrow_upward,
          tooltip: '上一级',
          onPressed: fileProvider.navigateUp,
        ),
      ],
    );
  }

  Widget _buildPathDisplay(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.folder_open, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileProvider.currentPath,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 32,
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索文件或文件夹...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade600),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: const Color(0xFF0078D4).withOpacity(0.5), width: 1.5),
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        onChanged: (value) {
          final fileProvider = Provider.of<FileProvider>(context, listen: false);
          fileProvider.searchFiles(value);
        },
      ),
    );
  }

  Widget _buildViewButtons(BuildContext context) {
    return Row(
      children: [
        _buildToolbarButton(
          icon: Icons.refresh,
          tooltip: '刷新',
          onPressed: () {
            final fileProvider = Provider.of<FileProvider>(context, listen: false);
            fileProvider.refresh();
          },
        ),
        _buildToolbarButton(
          icon: Icons.view_list,
          tooltip: '列表视图',
          onPressed: () {
            // TODO: 实现视图切换
          },
        ),
        _buildToolbarButton(
          icon: Icons.view_module,
          tooltip: '图标视图',
          onPressed: () {
            // TODO: 实现视图切换
          },
        ),
      ],
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    bool enabled = true,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: enabled ? onPressed : null,
      iconSize: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
      style: WindowsTheme.modernIconButtonStyle,
    );
  }
}