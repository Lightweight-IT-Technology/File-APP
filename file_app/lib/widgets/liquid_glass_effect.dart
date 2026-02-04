import 'package:flutter/material.dart';
import 'dart:ui';

/// 液态玻璃效果组件 - 实现Apple Liquid Glass设计风格
class LiquidGlassEffect extends StatefulWidget {
  final Widget child;
  final double blurIntensity;
  final double opacity;
  final Color glassColor;
  final bool enableAnimations;
  final double borderRadius;
  
  const LiquidGlassEffect({
    Key? key,
    required this.child,
    this.blurIntensity = 15.0,
    this.opacity = 0.15,
    this.glassColor = Colors.white,
    this.enableAnimations = true,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  State<LiquidGlassEffect> createState() => _LiquidGlassEffectState();
}

class _LiquidGlassEffectState extends State<LiquidGlassEffect> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _blurAnimation = Tween<double>(
      begin: widget.blurIntensity * 0.8,
      end: widget.blurIntensity * 1.2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )..addListener(() {
        if (mounted) setState(() {});
      }),
    );
    
    _opacityAnimation = Tween<double>(
      begin: widget.opacity * 0.9,
      end: widget.opacity * 1.1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )..addListener(() {
        if (mounted) setState(() {});
      }),
    );
    
    if (widget.enableAnimations) {
      _animationController.repeat(reverse: true);
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final currentBlur = widget.enableAnimations ? _blurAnimation.value : widget.blurIntensity;
    final currentOpacity = widget.enableAnimations ? _opacityAnimation.value : widget.opacity;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // 玻璃磨砂效果
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: currentBlur * 0.3,
            spreadRadius: -2,
            offset: const Offset(-2, -2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: currentBlur * 0.5,
            spreadRadius: -1,
            offset: const Offset(2, 2),
          ),
          // 内发光效果
          BoxShadow(
            color: widget.glassColor.withOpacity(0.05),
            blurRadius: currentBlur * 0.2,
            spreadRadius: 1,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: _createBlurFilter(currentBlur),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.glassColor.withOpacity(currentOpacity * 0.8),
                  widget.glassColor.withOpacity(currentOpacity * 1.2),
                  widget.glassColor.withOpacity(currentOpacity * 0.6),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
  
  ImageFilter _createBlurFilter(double intensity) {
    return ImageFilter.blur(
      sigmaX: intensity * 0.5,
      sigmaY: intensity * 0.5,
    );
  }
}

/// 液态玻璃按钮组件
class LiquidGlassButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double borderRadius;
  final Color highlightColor;
  final bool enableRippleEffect;
  
  const LiquidGlassButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius = 12.0,
    this.highlightColor = Colors.white,
    this.enableRippleEffect = true,
  }) : super(key: key);

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }
  
  void _handleTap() {
    if (widget.enableRippleEffect) {
      _rippleController.forward().then((_) {
        _rippleController.reverse();
      });
    }
    widget.onPressed();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _rippleAnimation,
        builder: (context, child) {
          return LiquidGlassEffect(
            blurIntensity: 10.0,
            opacity: 0.2,
            borderRadius: widget.borderRadius,
            enableAnimations: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    widget.highlightColor.withOpacity(_rippleAnimation.value * 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// 液态玻璃卡片组件
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  
  const LiquidGlassCard({
    Key? key,
    required this.child,
    this.elevation = 4.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassEffect(
      blurIntensity: 12.0,
      opacity: 0.18,
      borderRadius: borderRadius,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// 液态玻璃背景容器
class LiquidGlassBackground extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final double blurIntensity;
  final bool enableDynamicEffects;
  
  const LiquidGlassBackground({
    Key? key,
    required this.child,
    this.baseColor = Colors.white,
    this.blurIntensity = 20.0,
    this.enableDynamicEffects = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.02),
            baseColor.withOpacity(0.05),
            baseColor.withOpacity(0.02),
          ],
        ),
      ),
      child: enableDynamicEffects
          ? _buildDynamicBackground(child)
          : child,
    );
  }
  
  Widget _buildDynamicBackground(Widget child) {
    return Stack(
      children: [
        // 背景动态效果层
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 10),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  baseColor.withOpacity(0.03),
                  baseColor.withOpacity(0.01),
                ],
              ),
            ),
          ),
        ),
        // 内容层
        child,
      ],
    );
  }
}