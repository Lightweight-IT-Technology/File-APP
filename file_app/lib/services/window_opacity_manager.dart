import 'package:flutter/material.dart';

/// 窗口透明度管理器 - 提供应用程序窗口透明度控制功能
class WindowOpacityManager {
  static final WindowOpacityManager _instance = WindowOpacityManager._internal();
  
  factory WindowOpacityManager() {
    return _instance;
  }
  
  WindowOpacityManager._internal();
  
  /// 当前窗口透明度 (0.0 - 1.0)
  double _currentOpacity = 1.0;
  
  /// 透明度变化监听器
  final List<Function(double)> _listeners = [];
  
  /// 设置窗口透明度
  /// [opacity] 透明度值，范围 0.1 - 1.0
  Future<void> setWindowOpacity(double opacity) async {
    try {
      // 限制透明度范围
      final clampedOpacity = opacity.clamp(0.1, 1.0);
      
      // 更新当前透明度
      _currentOpacity = clampedOpacity;
      
      // 通知监听器
      _notifyListeners(clampedOpacity);
      
      print('窗口透明度已设置为: $clampedOpacity');
      
      // 在实际应用中，这里可以调用平台特定的API
      // 由于Flutter限制，我们使用UI层面的透明度效果
      await _applyOpacityEffect(clampedOpacity);
      
    } catch (e) {
      print('设置窗口透明度失败: $e');
      // 不抛出异常，保持应用稳定
    }
  }
  
  /// 获取当前窗口透明度
  double getWindowOpacity() {
    return _currentOpacity;
  }
  
  /// 添加透明度变化监听器
  void addListener(Function(double) listener) {
    _listeners.add(listener);
  }
  
  /// 移除透明度变化监听器
  void removeListener(Function(double) listener) {
    _listeners.remove(listener);
  }
  
  /// 通知所有监听器
  void _notifyListeners(double opacity) {
    for (final listener in _listeners) {
      try {
        listener(opacity);
      } catch (e) {
        print('通知透明度监听器失败: $e');
      }
    }
  }
  
  /// 应用透明度效果
  Future<void> _applyOpacityEffect(double opacity) async {
    // 由于Flutter在Windows平台上直接控制窗口透明度比较复杂
    // 我们使用UI层面的透明度效果来模拟窗口透明度
    
    // 方法1: 使用全局透明度效果（通过主题或全局样式）
    await _applyGlobalOpacityEffect(opacity);
    
    // 方法2: 使用背景模糊效果增强透明度感知
    await _applyBackgroundBlurEffect(opacity);
  }
  
  /// 应用全局透明度效果
  Future<void> _applyGlobalOpacityEffect(double opacity) async {
    // 这里实现全局透明度效果
    // 在实际应用中，可以通过修改主题或全局样式来实现
    
    // 模拟实现：记录透明度值，供UI组件使用
    print('应用全局透明度效果: $opacity');
  }
  
  /// 应用背景模糊效果
  Future<void> _applyBackgroundBlurEffect(double opacity) async {
    // 使用背景模糊效果增强透明度感知
    // 较低的透明度配合模糊效果可以创造更好的视觉体验
    
    final blurIntensity = (1.0 - opacity) * 10.0; // 根据透明度调整模糊强度
    print('应用背景模糊效果，强度: $blurIntensity');
  }
  
  /// 渐变调整透明度
  Future<void> animateOpacity(double targetOpacity, {int durationMs = 500}) async {
    final startOpacity = _currentOpacity;
    final steps = durationMs ~/ 16; // 约60fps
    
    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      final currentOpacity = startOpacity + (targetOpacity - startOpacity) * progress;
      
      await setWindowOpacity(currentOpacity);
      await Future.delayed(const Duration(milliseconds: 16));
    }
    
    await setWindowOpacity(targetOpacity);
  }
  
  /// 重置为默认透明度
  Future<void> resetToDefault() async {
    await setWindowOpacity(1.0);
  }
  
  /// 获取透明度对应的颜色
  Color getOpacityColor(Color baseColor) {
    return baseColor.withOpacity(_currentOpacity);
  }
  
  /// 获取透明度对应的背景装饰
  BoxDecoration getOpacityDecoration({Color? baseColor}) {
    final color = baseColor ?? Colors.white;
    return BoxDecoration(
      color: color.withOpacity(_currentOpacity),
      // 添加模糊效果增强透明度感知
      boxShadow: _currentOpacity < 0.8 ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.1 * (1.0 - _currentOpacity)),
          blurRadius: 10.0 * (1.0 - _currentOpacity),
          spreadRadius: 2.0 * (1.0 - _currentOpacity),
        )
      ] : [],
    );
  }
}

/// 窗口透明度提供者 - 用于在Widget树中共享窗口透明度状态
class WindowOpacityProvider extends InheritedWidget {
  final WindowOpacityManager manager;
  final double currentOpacity;
  
  const WindowOpacityProvider({
    Key? key,
    required this.manager,
    required this.currentOpacity,
    required Widget child,
  }) : super(key: key, child: child);
  
  static WindowOpacityProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WindowOpacityProvider>();
  }
  
  @override
  bool updateShouldNotify(WindowOpacityProvider oldWidget) {
    return oldWidget.currentOpacity != currentOpacity;
  }
}

/// 支持窗口透明度的容器组件
class TransparentWindowContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  
  const TransparentWindowContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.margin,
    this.padding,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final opacityProvider = WindowOpacityProvider.of(context);
    final manager = opacityProvider?.manager ?? WindowOpacityManager();
    
    return Container(
      margin: margin,
      padding: padding,
      decoration: manager.getOpacityDecoration(baseColor: backgroundColor),
      child: child,
    );
  }
}

/// 支持窗口透明度的文本组件
class TransparentWindowText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const TransparentWindowText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final opacityProvider = WindowOpacityProvider.of(context);
    final manager = opacityProvider?.manager ?? WindowOpacityManager();
    
    final baseStyle = style ?? const TextStyle();
    final opacityStyle = baseStyle.copyWith(
      color: manager.getOpacityColor(baseStyle.color ?? Colors.black),
    );
    
    return Text(
      text,
      style: opacityStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}