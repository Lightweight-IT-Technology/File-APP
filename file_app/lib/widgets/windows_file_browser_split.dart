import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_provider.dart';
import '../providers/settings_provider.dart';
import '../models/file_model.dart';
import '../theme/windows_theme.dart';
import 'windows_toolbar.dart';
import 'windows_file_item.dart';
import 'windows_file_context_menu.dart';
import 'file_preview.dart';
import 'settings_dialog.dart';
import '../utils/path_utils.dart';
import '../services/window_opacity_manager.dart';
import 'liquid_glass_effect.dart';

class WindowsFileBrowserSplit extends StatelessWidget {
  const WindowsFileBrowserSplit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<FileProvider, SettingsProvider>(
      builder: (context, fileProvider, settingsProvider, child) {
        return LiquidGlassBackground(
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          enableDynamicEffects: settingsProvider.settings.enableAnimations,
          child: Scaffold(
            backgroundColor: Colors.transparent, // 完全透明背景
            body: Container(
              decoration: settingsProvider.getBackgroundDecoration(),
              child: Column(
                children: [
                  // 现代化工具栏
                  const WindowsToolbar(),
                  // 左右分栏内容区域
                  Expanded(
                    child: Row(
                      children: [
                        // 左侧文件栏 (液态玻璃设计)
                        LiquidGlassEffect(
                          blurIntensity:
                              settingsProvider.settings.blurIntensity,
                          opacity: settingsProvider.settings.uiOpacity * 0.8,
                          borderRadius: settingsProvider.settings.borderRadius,
                          enableAnimations:
                              settingsProvider.settings.enableAnimations,
                          glassColor: Theme.of(context).cardColor,
                          child: Container(
                            width: 200,
                            child: _buildSidebar(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 右侧文件显示区
                        Expanded(
                          child: LiquidGlassCard(
                            borderRadius:
                                settingsProvider.settings.borderRadius,
                            padding: const EdgeInsets.all(16),
                            child: _buildFileDisplayArea(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 现代化状态栏
                  _buildStatusBar(context),
                ],
              ),
            ),
            floatingActionButton: LiquidGlassButton(
              onPressed: () => _showSettingsDialog(context),
              borderRadius: 20,
              child: const Icon(Icons.settings, size: 18),
            ),
          ),
        );
      },
    );
  }

  // 左侧文件栏
  Widget _buildSidebar(BuildContext context) {
    return Column(
      children: [
        // 快速访问区域
        _buildQuickAccess(context),
        // 分隔线
        const Divider(height: 1, color: Color(0xFFE1E1E1)),
        // 驱动器列表
        _buildDriveList(context),
        // 分隔线
        const Divider(height: 1, color: Color(0xFFE1E1E1)),
        // 文件夹树形结构
        Expanded(child: _buildFolderTree(context)),
      ],
    );
  }

  // 快速访问区域
  Widget _buildQuickAccess(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '快速访问',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          _buildQuickAccessItem(
            context,
            '桌面',
            Icons.desktop_windows,
            PathUtils.desktopPath,
          ),
          _buildQuickAccessItem(
            context,
            '下载',
            Icons.file_download,
            PathUtils.downloadsPath,
          ),
          _buildQuickAccessItem(
            context,
            '文档',
            Icons.folder,
            PathUtils.documentsPath,
          ),
          _buildQuickAccessItem(
            context,
            '图片',
            Icons.photo_library,
            PathUtils.picturesPath,
          ),
          _buildQuickAccessItem(
            context,
            '音乐',
            Icons.music_note,
            PathUtils.musicPath,
          ),
          _buildQuickAccessItem(
            context,
            '视频',
            Icons.video_library,
            PathUtils.videosPath,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem(
    BuildContext context,
    String title,
    IconData icon,
    String path,
  ) {
    return Container(
      height: 28,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToPath(context, path);
          },
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 驱动器列表
  Widget _buildDriveList(BuildContext context) {
    final drives = PathUtils.getSystemDrives();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '此电脑',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          // 动态生成驱动器列表
          ...drives.map((drivePath) {
            final displayName = PathUtils.getDisplayName(drivePath);
            return _buildDriveItem(
              context,
              displayName,
              Icons.storage,
              drivePath,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDriveItem(
    BuildContext context,
    String title,
    IconData icon,
    String path,
  ) {
    return Container(
      height: 28,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToPath(context, path);
          },
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 文件夹树形结构
  Widget _buildFolderTree(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          // 用户文件夹
          _buildFolderTreeItem(
            context,
            '用户',
            Icons.person,
            PathUtils.userHomePath,
            true,
          ),
          _buildFolderTreeItem(
            context,
            '桌面',
            Icons.desktop_windows,
            PathUtils.desktopPath,
            false,
            level: 1,
          ),
          _buildFolderTreeItem(
            context,
            '文档',
            Icons.folder,
            PathUtils.documentsPath,
            false,
            level: 1,
          ),
          _buildFolderTreeItem(
            context,
            '下载',
            Icons.file_download,
            PathUtils.downloadsPath,
            false,
            level: 1,
          ),
          _buildFolderTreeItem(
            context,
            '图片',
            Icons.photo_library,
            PathUtils.picturesPath,
            false,
            level: 1,
          ),
          _buildFolderTreeItem(
            context,
            '音乐',
            Icons.music_note,
            PathUtils.musicPath,
            false,
            level: 1,
          ),
          _buildFolderTreeItem(
            context,
            '视频',
            Icons.video_library,
            PathUtils.videosPath,
            false,
            level: 1,
          ),

          // 系统驱动器
          ...PathUtils.getSystemDrives().map((drivePath) {
            final displayName = PathUtils.getDisplayName(drivePath);
            return _buildFolderTreeItem(
              context,
              displayName,
              Icons.storage,
              drivePath,
              true,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFolderTreeItem(
    BuildContext context,
    String title,
    IconData icon,
    String path,
    bool expanded, {
    int level = 0,
  }) {
    return Container(
      height: 24,
      padding: EdgeInsets.only(left: level * 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToPath(context, path);
          },
          child: Row(
            children: [
              if (level > 0) const SizedBox(width: 4),
              Icon(
                expanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 右侧文件显示区
  Widget _buildFileDisplayArea(BuildContext context) {
    return Column(
      children: [
        // 文件列表标题栏
        _buildListHeader(),
        // 文件列表
        Expanded(child: _buildFileList(context)),
      ],
    );
  }

  Widget _buildListHeader() {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        border: const Border(bottom: BorderSide(color: Color(0xFFE1E1E1))),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (fileProvider.files.isEmpty) {
      return const Center(child: Text('文件夹为空'));
    }

    return ListView.builder(
      itemCount: fileProvider.files.length,
      itemBuilder: (context, index) {
        final file = fileProvider.files[index];
        return WindowsFileItem(
          file: file,
          isSelected: false, // TODO: 实现选中状态管理
          onTap: () {
            if (file.isDirectory) {
              fileProvider.navigateToDirectory(file.path);
            } else {
              // 文件预览
              _showFilePreview(context, file);
            }
          },
          onDoubleTap: () {
            if (file.isDirectory) {
              fileProvider.navigateToDirectory(file.path);
            } else {
              // 文件预览
              _showFilePreview(context, file);
            }
          },
          onLongPress: () {
            _showContextMenu(context, file);
          },
        );
      },
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(settingsProvider.getUIOpacity()),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            '${fileProvider.files.length} 个项目',
            style: TextStyle(
              fontSize: settingsProvider.getFontSize(),
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              fileProvider.currentPath,
              style: TextStyle(
                fontSize: settingsProvider.getFontSize(),
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  /// 显示设置对话框
  void _showSettingsDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const SettingsDialog());
  }

  void _navigateToPath(BuildContext context, String path) {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    // 检查路径是否存在
    if (!PathUtils.pathExists(path)) {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('路径不存在: $path'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // 导航到指定路径
    fileProvider.navigateToDirectory(path);
  }

  void _showFilePreview(BuildContext context, FileItem file) {
    showDialog(
      context: context,
      builder: (context) => FilePreview(file: file),
    );
  }

  void _showContextMenu(BuildContext context, FileItem file) {
    // 获取点击位置
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      builder: (context) => WindowsFileContextMenu(
        file: file,
        position: position,
        onDismiss: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
