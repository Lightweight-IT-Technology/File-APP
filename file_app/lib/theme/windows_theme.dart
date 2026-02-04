
import 'package:flutter/material.dart';

class WindowsTheme {
  // 现代化透明主题 - 浅色模式
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // 启用Material 3设计
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0078D4),
      scaffoldBackgroundColor: Colors.white.withOpacity(0.85), // 透明背景
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(0.7), // 半透明工具栏
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 48,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white.withOpacity(0.8),
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300.withOpacity(0.6),
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF0078D4),
        onPrimary: Colors.white,
        surface: Colors.white.withOpacity(0.8),
        onSurface: Colors.black87,
        surfaceVariant: Colors.white.withOpacity(0.6),
      ),
    );
  }

  // 现代化透明主题 - 深色模式
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true, // 启用Material 3设计
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0078D4),
      scaffoldBackgroundColor: Colors.black.withOpacity(0.85), // 透明背景
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black.withOpacity(0.7), // 半透明工具栏
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 48,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.grey.shade900.withOpacity(0.8),
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade700.withOpacity(0.6),
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF0078D4),
        onPrimary: Colors.white,
        surface: Colors.grey.shade900.withOpacity(0.8),
        onSurface: Colors.white70,
        surfaceVariant: Colors.grey.shade800.withOpacity(0.6),
      ),
    );
  }

  // 现代化工具栏装饰
  static BoxDecoration get toolbarDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.7),
      border: Border.all(color: Colors.grey.shade300.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // 现代化选中项装饰
  static BoxDecoration get selectedItemDecoration {
    return BoxDecoration(
      color: const Color(0xFF0078D4).withOpacity(0.15),
      border: Border.all(color: const Color(0xFF0078D4).withOpacity(0.5)),
      borderRadius: BorderRadius.circular(6),
    );
  }

  // 现代化悬停项装饰
  static BoxDecoration get hoverItemDecoration {
    return BoxDecoration(
      color: Colors.grey.shade300.withOpacity(0.3),
      borderRadius: BorderRadius.circular(6),
    );
  }

  // 现代化侧边栏装饰
  static BoxDecoration get sidebarDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.6),
      border: Border.all(color: Colors.grey.shade300.withOpacity(0.2)),
    );
  }

  // 现代化文件列表装饰
  static BoxDecoration get fileListDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.7),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // 现代化状态栏装饰
  static BoxDecoration get statusBarDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.6),
      border: Border.all(color: Colors.grey.shade300.withOpacity(0.2)),
    );
  }

  // 现代化按钮样式
  static ButtonStyle get modernButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF0078D4).withOpacity(0.3);
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF0078D4).withOpacity(0.1);
          }
          return Colors.transparent;
        },
      ),
      foregroundColor: MaterialStateProperty.all(const Color(0xFF0078D4)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      elevation: MaterialStateProperty.all(0),
    );
  }

  // 现代化图标按钮样式
  static ButtonStyle get modernIconButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.grey.shade300.withOpacity(0.3);
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.grey.shade300.withOpacity(0.1);
          }
          return Colors.transparent;
        },
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      elevation: MaterialStateProperty.all(0),
    );
  }
}