import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

/// 设置提供者 - 管理应用程序的个性化设置
class SettingsProvider with ChangeNotifier {
  static const String _settingsKey = 'app_settings';
  
  AppSettings _settings = AppSettings();
  
  AppSettings get settings => _settings;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  /// 加载设置
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_settingsKey);
      
      if (settingsString != null) {
        final settingsMap = _parseSettingsString(settingsString);
        _settings = AppSettings.fromMap(settingsMap);
        notifyListeners();
      }
    } catch (e) {
      // 使用默认设置
      _settings = AppSettings();
    }
  }
  
  /// 保存设置
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = _settingsToJsonString(_settings.toMap());
      await prefs.setString(_settingsKey, settingsString);
    } catch (e) {
      // 忽略保存错误
    }
  }
  
  /// 解析设置字符串
  Map<String, dynamic> _parseSettingsString(String settingsString) {
    try {
      final parts = settingsString.split('|');
      final Map<String, dynamic> settingsMap = {};
      
      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          final key = keyValue[0];
          final value = keyValue[1];
          
          // 根据键名解析值
          switch (key) {
            case 'uiOpacity':
            case 'windowOpacity':
            case 'blurIntensity':
            case 'fontSize':
            case 'borderRadius':
            case 'animationSpeed':
              settingsMap[key] = double.tryParse(value) ?? 0.0;
              break;
            case 'backgroundColor':
            case 'gradientStartColor':
            case 'gradientEndColor':
              settingsMap[key] = int.tryParse(value) ?? Colors.white.value;
              break;
            case 'backgroundType':
            case 'themeMode':
              settingsMap[key] = int.tryParse(value) ?? 0;
              break;
            case 'enableGradientBackground':
            case 'enableBlurEffect':
            case 'enableAnimations':
              settingsMap[key] = value == 'true';
              break;
            case 'backgroundImagePath':
              settingsMap[key] = value;
              break;
          }
        }
      }
      
      return settingsMap;
    } catch (e) {
      return {};
    }
  }
  
  /// 将设置转换为JSON字符串
  String _settingsToJsonString(Map<String, dynamic> settingsMap) {
    final List<String> parts = [];
    
    settingsMap.forEach((key, value) {
      if (value != null) {
        parts.add('$key:$value');
      }
    });
    
    return parts.join('|');
  }
  
  /// 更新UI透明度
  Future<void> updateUIOpacity(double opacity) async {
    _settings = _settings.copyWith(uiOpacity: opacity.clamp(0.1, 1.0));
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新窗口透明度
  Future<void> updateWindowOpacity(double opacity) async {
    _settings = _settings.copyWith(windowOpacity: opacity.clamp(0.1, 1.0));
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新背景类型
  Future<void> updateBackgroundType(BackgroundType type) async {
    _settings = _settings.copyWith(backgroundType: type);
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新背景颜色
  Future<void> updateBackgroundColor(Color color) async {
    _settings = _settings.copyWith(backgroundColor: color);
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新背景图片路径
  Future<void> updateBackgroundImagePath(String path) async {
    _settings = _settings.copyWith(backgroundImagePath: path);
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新渐变背景
  Future<void> updateGradientBackground(bool enabled, {Color? startColor, Color? endColor}) async {
    _settings = _settings.copyWith(
      enableGradientBackground: enabled,
      gradientStartColor: startColor ?? _settings.gradientStartColor,
      gradientEndColor: endColor ?? _settings.gradientEndColor,
    );
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新渐变颜色
  Future<void> updateGradientColors(Color startColor, Color endColor) async {
    _settings = _settings.copyWith(
      gradientStartColor: startColor,
      gradientEndColor: endColor,
    );
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新模糊效果
  Future<void> updateBlurEffect(bool enabled, double intensity) async {
    _settings = _settings.copyWith(
      enableBlurEffect: enabled,
      blurIntensity: intensity.clamp(0.0, 20.0),
    );
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新字体大小
  Future<void> updateFontSize(double size) async {
    _settings = _settings.copyWith(fontSize: size.clamp(10.0, 24.0));
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新圆角大小
  Future<void> updateBorderRadius(double radius) async {
    _settings = _settings.copyWith(borderRadius: radius.clamp(0.0, 20.0));
    await _saveSettings();
    notifyListeners();
  }
  
  /// 更新动画设置
  Future<void> updateAnimationSettings(bool enabled, double speed) async {
    _settings = _settings.copyWith(
      enableAnimations: enabled,
      animationSpeed: speed.clamp(0.5, 2.0),
    );
    await _saveSettings();
    notifyListeners();
  }
  
  /// 应用预设背景主题
  Future<void> applyBackgroundTheme(BackgroundTheme theme) async {
    _settings = _settings.copyWith(
      backgroundType: theme.type,
      backgroundColor: theme.startColor,
      gradientStartColor: theme.startColor,
      gradientEndColor: theme.endColor,
      backgroundImagePath: theme.imagePath ?? '',
    );
    await _saveSettings();
    notifyListeners();
  }
  
  /// 重置为默认设置
  Future<void> resetToDefaults() async {
    _settings = AppSettings();
    await _saveSettings();
    notifyListeners();
  }
  
  /// 获取当前背景装饰
  BoxDecoration getBackgroundDecoration() {
    switch (_settings.backgroundType) {
      case BackgroundType.solid:
        return BoxDecoration(
          color: _settings.backgroundColor.withOpacity(_settings.uiOpacity),
        );
      case BackgroundType.gradient:
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _settings.gradientStartColor.withOpacity(_settings.uiOpacity),
              _settings.gradientEndColor.withOpacity(_settings.uiOpacity),
            ],
          ),
        );
      case BackgroundType.image:
        return BoxDecoration(
          image: _settings.backgroundImagePath.isNotEmpty
              ? DecorationImage(
                  image: FileImage(_settings.backgroundImagePath as dynamic),
                  fit: BoxFit.cover,
                  opacity: _settings.uiOpacity,
                )
              : null,
          color: Colors.transparent,
        );
      case BackgroundType.transparent:
        return const BoxDecoration(
          color: Colors.transparent,
        );
    }
  }
  
  /// 获取窗口透明度
  double getWindowOpacity() {
    return _settings.windowOpacity;
  }
  
  /// 获取UI组件透明度
  double getUIOpacity() {
    return _settings.uiOpacity;
  }
  
  /// 获取字体大小
  double getFontSize() {
    return _settings.fontSize;
  }
  
  /// 获取圆角大小
  double getBorderRadius() {
    return _settings.borderRadius;
  }
  
  /// 是否启用动画
  bool get enableAnimations => _settings.enableAnimations;
  
  /// 获取动画速度
  double get animationSpeed => _settings.animationSpeed;
}