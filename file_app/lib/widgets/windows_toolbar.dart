
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import '../theme/windows_theme.dart';

class WindowsToolbar extends StatelessWidget {
  const WindowsToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: WindowsTheme.toolbarDecoration,
      child: Row(
        children: [
          // 导航按钮
          _buildNavigationButtons(context),
          const VerticalDivider(width: 1),
          // 路径显示
          _buildPathDisplay(context),
          const Spacer(),
          // 搜索框
          _buildSearchBox(context),
          const SizedBox(width: 8),
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
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Icon(Icons.folder, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                fileProvider.currentPath,
                style: const TextStyle(fontSize: 12),
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
      width: 200,
      height: 24,
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索...',
          hintStyle: const TextStyle(fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFF0078D4)),
          ),
          prefixIcon: const Icon(Icons.search, size: 16),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 12),
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
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return Container(
      width: 32,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Icon(
              icon,
              size: 16,
              color: enabled ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}