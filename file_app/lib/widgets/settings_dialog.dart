import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/settings_model.dart';
import 'liquid_glass_effect.dart';

/// 设置对话框 - 提供个性化设置界面
class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: LiquidGlassEffect(
        blurIntensity: 25.0,
        opacity: 0.2,
        borderRadius: 20.0,
        enableAnimations: settingsProvider.settings.enableAnimations,
        child: Container(
          width: 600,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // 标题栏
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.15),
                      Theme.of(context).primaryColor.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '个性化设置',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: LiquidGlassButton(
                        onPressed: () => Navigator.of(context).pop(),
                        borderRadius: 12,
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // 标签页
              Container(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: '透明度'),
                    Tab(text: '背景'),
                    Tab(text: '外观'),
                    Tab(text: '动画'),
                  ],
                ),
              ),

              // 内容区域
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOpacityTab(settingsProvider),
                    _buildBackgroundTab(settingsProvider),
                    _buildAppearanceTab(settingsProvider),
                    _buildAnimationTab(settingsProvider),
                  ],
                ),
              ),

              // 底部按钮
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.08),
                      Theme.of(context).primaryColor.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LiquidGlassButton(
                      onPressed: () => _resetToDefaults(settingsProvider),
                      borderRadius: 8,
                      child: Row(
                        children: [
                          Icon(Icons.restore, size: 14),
                          const SizedBox(width: 4),
                          const Text('重置默认设置', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        LiquidGlassButton(
                          onPressed: () => Navigator.of(context).pop(),
                          borderRadius: 8,
                          child: const Text('取消', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        LiquidGlassButton(
                          onPressed: () => Navigator.of(context).pop(),
                          borderRadius: 8,
                          highlightColor: Theme.of(context).primaryColor,
                          child: const Text('应用', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 透明度设置标签页
  Widget _buildOpacityTab(SettingsProvider settingsProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('UI组件透明度设置'),
          _buildSliderSetting(
            label: 'UI组件透明度',
            value: settingsProvider.settings.uiOpacity,
            min: 0.1,
            max: 1.0,
            onChanged: (value) => settingsProvider.updateUIOpacity(value),
            valueText: '${(settingsProvider.settings.uiOpacity * 100).round()}%',
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('应用程序窗口透明度设置'),
          _buildSliderSetting(
            label: '窗口透明度',
            value: settingsProvider.settings.windowOpacity,
            min: 0.1,
            max: 1.0,
            onChanged: (value) => settingsProvider.updateWindowOpacity(value),
            valueText: '${(settingsProvider.settings.windowOpacity * 100).round()}%',
          ),

          const SizedBox(height: 16),
          _buildInfoText('调整窗口透明度会影响整个应用程序窗口的透明度效果'),

          const SizedBox(height: 16),
          _buildSwitchSetting(
            label: '启用渐变过渡效果',
            value: true,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value ? '已启用渐变过渡效果' : '已禁用渐变过渡效果')),
              );
            },
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('预览效果'),
                  onPressed: () => _previewWindowOpacity(settingsProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.restore, size: 16),
                  label: const Text('重置窗口'),
                  onPressed: () => _resetWindowOpacity(settingsProvider),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 背景设置标签页
  Widget _buildBackgroundTab(SettingsProvider settingsProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('背景类型'),
          _buildBackgroundTypeSelector(settingsProvider),

          const SizedBox(height: 24),
          _buildSectionTitle('预设主题'),
          _buildThemePresets(settingsProvider),

          const SizedBox(height: 24),
          _buildSectionTitle('自定义设置'),
          if (settingsProvider.settings.backgroundType == BackgroundType.solid)
            _buildColorPicker(
              label: '背景颜色',
              color: settingsProvider.settings.backgroundColor,
              onColorChanged: (color) => settingsProvider.updateBackgroundColor(color),
            ),

          if (settingsProvider.settings.backgroundType == BackgroundType.gradient)
            Column(
              children: [
                _buildColorPicker(
                  label: '渐变开始颜色',
                  color: settingsProvider.settings.gradientStartColor,
                  onColorChanged: (color) => settingsProvider.updateGradientColors(
                    color,
                    settingsProvider.settings.gradientEndColor,
                  ),
                ),
                const SizedBox(height: 12),
                _buildColorPicker(
                  label: '渐变结束颜色',
                  color: settingsProvider.settings.gradientEndColor,
                  onColorChanged: (color) => settingsProvider.updateGradientColors(
                    settingsProvider.settings.gradientStartColor,
                    color,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),
          _buildSwitchSetting(
            label: '启用模糊效果',
            value: settingsProvider.settings.enableBlurEffect,
            onChanged: (value) => settingsProvider.updateBlurEffect(
              value,
              settingsProvider.settings.blurIntensity,
            ),
          ),

          if (settingsProvider.settings.enableBlurEffect)
            _buildSliderSetting(
              label: '模糊强度',
              value: settingsProvider.settings.blurIntensity,
              min: 0.0,
              max: 20.0,
              onChanged: (value) => settingsProvider.updateBlurEffect(true, value),
              valueText: '${settingsProvider.settings.blurIntensity.round()}px',
            ),
        ],
      ),
    );
  }

  /// 外观设置标签页
  Widget _buildAppearanceTab(SettingsProvider settingsProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('主题模式'),
          _buildThemeModeSelector(settingsProvider),

          const SizedBox(height: 24),
          _buildSectionTitle('字体设置'),
          _buildSliderSetting(
            label: '字体大小',
            value: settingsProvider.settings.fontSize,
            min: 10.0,
            max: 24.0,
            onChanged: (value) => settingsProvider.updateFontSize(value),
            valueText: '${settingsProvider.settings.fontSize.round()}px',
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('界面样式'),
          _buildSliderSetting(
            label: '圆角大小',
            value: settingsProvider.settings.borderRadius,
            min: 0.0,
            max: 20.0,
            onChanged: (value) => settingsProvider.updateBorderRadius(value),
            valueText: '${settingsProvider.settings.borderRadius.round()}px',
          ),
        ],
      ),
    );
  }

  /// 动画设置标签页
  Widget _buildAnimationTab(SettingsProvider settingsProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('动画设置'),
          _buildSwitchSetting(
            label: '启用动画效果',
            value: settingsProvider.settings.enableAnimations,
            onChanged: (value) => settingsProvider.updateAnimationSettings(
              value,
              settingsProvider.settings.animationSpeed,
            ),
          ),

          if (settingsProvider.settings.enableAnimations)
            _buildSliderSetting(
              label: '动画速度',
              value: settingsProvider.settings.animationSpeed,
              min: 0.5,
              max: 2.0,
              onChanged: (value) => settingsProvider.updateAnimationSettings(true, value),
              valueText: '${(settingsProvider.settings.animationSpeed * 100).round()}%',
            ),

          const SizedBox(height: 16),
          _buildInfoText('动画效果包括页面切换、按钮悬停等交互效果'),
        ],
      ),
    );
  }

  /// 构建部分标题
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  /// 构建滑块设置
  Widget _buildSliderSetting({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String valueText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text(
              valueText,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          divisions: (max - min).round() * 10,
        ),
      ],
    );
  }

  /// 构建开关设置
  Widget _buildSwitchSetting({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  /// 构建背景类型选择器
  Widget _buildBackgroundTypeSelector(SettingsProvider settingsProvider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: BackgroundType.values.map((type) {
        final isSelected = settingsProvider.settings.backgroundType == type;
        return ChoiceChip(
          label: Text(_getBackgroundTypeName(type)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              settingsProvider.updateBackgroundType(type);
            }
          },
        );
      }).toList(),
    );
  }

  /// 构建主题模式选择器
  Widget _buildThemeModeSelector(SettingsProvider settingsProvider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ThemeMode.values.map((mode) {
        final isSelected = settingsProvider.settings.themeMode == mode;
        return ChoiceChip(
          label: Text(_getThemeModeName(mode)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              settingsProvider.updateThemeMode(mode);
            }
          },
        );
      }).toList(),
    );
  }

  /// 构建主题预设
  Widget _buildThemePresets(SettingsProvider settingsProvider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: BackgroundThemes.themes.map((theme) {
        return GestureDetector(
          onTap: () => settingsProvider.applyBackgroundTheme(theme),
          child: Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.startColor, theme.endColor],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                theme.name,
                style: TextStyle(
                  fontSize: 10,
                  color: _getTextColorForBackground(theme.startColor),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建颜色选择器
  Widget _buildColorPicker({
    required String label,
    required Color color,
    required ValueChanged<Color> onColorChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        GestureDetector(
          onTap: () => _showColorPickerDialog(color, onColorChanged),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建信息文本
  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade600,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// 显示颜色选择对话框
  void _showColorPickerDialog(
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            color: currentColor,
            onColorChanged: onColorChanged,
            showLabel: true,
            pickerColor: currentColor,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('确定'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 预览窗口透明度效果
  void _previewWindowOpacity(SettingsProvider settingsProvider) {
    final currentOpacity = settingsProvider.settings.windowOpacity;
    final targetOpacity = currentOpacity < 0.5 ? 0.8 : 0.3;

    settingsProvider.windowOpacityManager
        .animateOpacity(targetOpacity, durationMs: 300)
        .then((_) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            settingsProvider.windowOpacityManager.animateOpacity(
              currentOpacity,
              durationMs: 300,
            );
          });
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正在预览窗口透明度效果...')),
    );
  }

  /// 重置窗口透明度
  void _resetWindowOpacity(SettingsProvider settingsProvider) {
    settingsProvider.updateWindowOpacity(1.0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('窗口透明度已重置为默认值')),
    );
  }

  /// 重置为默认设置
  void _resetToDefaults(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置为默认值吗？'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('重置'),
            onPressed: () {
              settingsProvider.resetToDefaults();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// 获取背景类型名称
  String _getBackgroundTypeName(BackgroundType type) {
    switch (type) {
      case BackgroundType.solid:
        return '纯色';
      case BackgroundType.gradient:
        return '渐变';
      case BackgroundType.image:
        return '图片';
      case BackgroundType.transparent:
        return '透明';
    }
  }

  /// 获取主题模式名称
  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '系统默认';
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
    }
  }

  /// 根据背景颜色获取文本颜色
  Color _getTextColorForBackground(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}

/// 简单的颜色选择器组件
class ColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool showLabel;
  final Color pickerColor;

  const ColorPicker({
    Key? key,
    required this.color,
    required this.onColorChanged,
    this.showLabel = false,
    required this.pickerColor,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel)
          Text(
            '当前颜色: ${_currentColor.value.toRadixString(16)}',
            style: const TextStyle(fontSize: 12),
          ),

        const SizedBox(height: 16),

        // 基本颜色选择
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _getBasicColors().map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentColor = color;
                });
                widget.onColorChanged(color);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _currentColor == color ? Colors.blue : Colors.grey,
                    width: _currentColor == color ? 2 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 获取基本颜色列表
  List<Color> _getBasicColors() {
    return [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];
  }
}