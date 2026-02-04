import 'package:flutter/material.dart';

/// 个性化设置数据模型
class AppSettings {
  /// UI透明度 (0.0 - 1.0)
  double uiOpacity;

  /// 窗口透明度 (0.0 - 1.0)
  double windowOpacity;

  /// 窗口背景类型
  BackgroundType backgroundType;

  /// 背景颜色
  Color backgroundColor;

  /// 背景图片路径
  String backgroundImagePath;

  /// 是否启用渐变背景
  bool enableGradientBackground;

  /// 渐变开始颜色
  Color gradientStartColor;

  /// 渐变结束颜色
  Color gradientEndColor;

  /// 是否启用模糊效果
  bool enableBlurEffect;

  /// 模糊强度 (0.0 - 20.0)
  double blurIntensity;

  /// 主题模式
  ThemeMode themeMode;

  /// 字体大小
  double fontSize;

  /// 圆角大小
  double borderRadius;

  /// 是否启用动画效果
  bool enableAnimations;

  /// 动画速度 (0.5 - 2.0)
  double animationSpeed;

  /// 是否启用液态玻璃效果
  bool enableLiquidGlassEffect;

  /// 液态玻璃效果强度 (0.0 - 1.0)
  double liquidGlassIntensity;

  /// 液态玻璃颜色
  Color liquidGlassColor;

  /// 是否启用液态流动动画
  bool enableLiquidFlowAnimation;

  /// 液态流动速度 (0.5 - 3.0)
  double liquidFlowSpeed;

  AppSettings({
    this.uiOpacity = 0.85,
    this.windowOpacity = 0.95,
    this.backgroundType = BackgroundType.solid,
    this.backgroundColor = Colors.white,
    this.backgroundImagePath = '',
    this.enableGradientBackground = true,
    this.gradientStartColor = Colors.white,
    this.gradientEndColor = Colors.white,
    this.enableBlurEffect = false,
    this.blurIntensity = 5.0,
    this.themeMode = ThemeMode.system,
    this.fontSize = 14.0,
    this.borderRadius = 8.0,
    this.enableAnimations = true,
    this.animationSpeed = 1.0,
    this.enableLiquidGlassEffect = true,
    this.liquidGlassIntensity = 0.7,
    this.liquidGlassColor = Colors.white,
    this.enableLiquidFlowAnimation = true,
    this.liquidFlowSpeed = 1.0,
  });

  /// 复制设置
  AppSettings copyWith({
    double? uiOpacity,
    double? windowOpacity,
    BackgroundType? backgroundType,
    Color? backgroundColor,
    String? backgroundImagePath,
    bool? enableGradientBackground,
    Color? gradientStartColor,
    Color? gradientEndColor,
    bool? enableBlurEffect,
    double? blurIntensity,
    ThemeMode? themeMode,
    double? fontSize,
    double? borderRadius,
    bool? enableAnimations,
    double? animationSpeed,
    bool? enableLiquidGlassEffect,
    double? liquidGlassIntensity,
    Color? liquidGlassColor,
    bool? enableLiquidFlowAnimation,
    double? liquidFlowSpeed,
  }) {
    return AppSettings(
      uiOpacity: uiOpacity ?? this.uiOpacity,
      windowOpacity: windowOpacity ?? this.windowOpacity,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      enableGradientBackground:
          enableGradientBackground ?? this.enableGradientBackground,
      gradientStartColor: gradientStartColor ?? this.gradientStartColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      enableBlurEffect: enableBlurEffect ?? this.enableBlurEffect,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      enableLiquidGlassEffect:
          enableLiquidGlassEffect ?? this.enableLiquidGlassEffect,
      liquidGlassIntensity: liquidGlassIntensity ?? this.liquidGlassIntensity,
      liquidGlassColor: liquidGlassColor ?? this.liquidGlassColor,
      enableLiquidFlowAnimation:
          enableLiquidFlowAnimation ?? this.enableLiquidFlowAnimation,
      liquidFlowSpeed: liquidFlowSpeed ?? this.liquidFlowSpeed,
    );
  }

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'uiOpacity': uiOpacity,
      'windowOpacity': windowOpacity,
      'backgroundType': backgroundType.index,
      'backgroundColor': backgroundColor.value,
      'backgroundImagePath': backgroundImagePath,
      'enableGradientBackground': enableGradientBackground,
      'gradientStartColor': gradientStartColor.value,
      'gradientEndColor': gradientEndColor.value,
      'enableBlurEffect': enableBlurEffect,
      'blurIntensity': blurIntensity,
      'themeMode': themeMode.index,
      'fontSize': fontSize,
      'borderRadius': borderRadius,
      'enableAnimations': enableAnimations,
      'animationSpeed': animationSpeed,
      'enableLiquidGlassEffect': enableLiquidGlassEffect,
      'liquidGlassIntensity': liquidGlassIntensity,
      'liquidGlassColor': liquidGlassColor.value,
      'enableLiquidFlowAnimation': enableLiquidFlowAnimation,
      'liquidFlowSpeed': liquidFlowSpeed,
    };
  }

  /// 从Map创建
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      uiOpacity: map['uiOpacity'] ?? 0.85,
      windowOpacity: map['windowOpacity'] ?? 0.95,
      backgroundType: BackgroundType.values[map['backgroundType'] ?? 0],
      backgroundColor: Color(map['backgroundColor'] ?? Colors.white.value),
      backgroundImagePath: map['backgroundImagePath'] ?? '',
      enableGradientBackground: map['enableGradientBackground'] ?? true,
      gradientStartColor: Color(
        map['gradientStartColor'] ?? Colors.white.value,
      ),
      gradientEndColor: Color(map['gradientEndColor'] ?? Colors.white.value),
      enableBlurEffect: map['enableBlurEffect'] ?? false,
      blurIntensity: map['blurIntensity'] ?? 5.0,
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
      fontSize: map['fontSize'] ?? 14.0,
      borderRadius: map['borderRadius'] ?? 8.0,
      enableAnimations: map['enableAnimations'] ?? true,
      animationSpeed: map['animationSpeed'] ?? 1.0,
      enableLiquidGlassEffect: map['enableLiquidGlassEffect'] ?? true,
      liquidGlassIntensity: map['liquidGlassIntensity'] ?? 0.7,
      liquidGlassColor: Color(map['liquidGlassColor'] ?? Colors.white.value),
      enableLiquidFlowAnimation: map['enableLiquidFlowAnimation'] ?? true,
      liquidFlowSpeed: map['liquidFlowSpeed'] ?? 1.0,
    );
  }
}

/// 背景类型枚举
enum BackgroundType {
  solid, // 纯色
  gradient, // 渐变
  image, // 图片
  transparent, // 透明
}

/// 预设背景主题
class BackgroundThemes {
  static List<BackgroundTheme> get themes => [
    BackgroundTheme(
      name: '默认',
      type: BackgroundType.gradient,
      startColor: Colors.white,
      endColor: const Color(0xFFB3B3B3), // Colors.white.withOpacity(0.7) 的近似值
    ),
    BackgroundTheme(
      name: '深色渐变',
      type: BackgroundType.gradient,
      startColor: Colors.black,
      endColor: const Color(0xFF212121), // Colors.grey.shade900 的近似值
    ),
    BackgroundTheme(
      name: '蓝色渐变',
      type: BackgroundType.gradient,
      startColor: const Color(0xFF0078D4),
      endColor: const Color(0xFF005A9E),
    ),
    BackgroundTheme(
      name: '紫色渐变',
      type: BackgroundType.gradient,
      startColor: const Color(0xFF9C27B0),
      endColor: const Color(0xFF7B1FA2),
    ),
    BackgroundTheme(
      name: '绿色渐变',
      type: BackgroundType.gradient,
      startColor: const Color(0xFF4CAF50),
      endColor: const Color(0xFF388E3C),
    ),
    BackgroundTheme(
      name: '透明',
      type: BackgroundType.transparent,
      startColor: Colors.transparent,
      endColor: Colors.transparent,
    ),
  ];
}

/// 背景主题
class BackgroundTheme {
  final String name;
  final BackgroundType type;
  final Color startColor;
  final Color endColor;
  final String? imagePath;

  const BackgroundTheme({
    required this.name,
    required this.type,
    required this.startColor,
    required this.endColor,
    this.imagePath,
  });
}
