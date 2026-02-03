
import 'package:flutter/material.dart';

class WindowsTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0078D4),
      scaffoldBackgroundColor: const Color(0xFFF3F3F3),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF3F3F3),
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 40,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE1E1E1),
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0078D4),
        onPrimary: Colors.white,
        surface: Color(0xFFF3F3F3),
        onSurface: Colors.black,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0078D4),
      scaffoldBackgroundColor: const Color(0xFF202020),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF404040),
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0078D4),
        onPrimary: Colors.white,
        surface: Color(0xFF2D2D2D),
        onSurface: Colors.white,
      ),
    );
  }

  static BoxDecoration get toolbarDecoration {
    return BoxDecoration(
      color: const Color(0xFFF3F3F3),
      border: Border.all(color: const Color(0xFFE1E1E1)),
    );
  }

  static BoxDecoration get selectedItemDecoration {
    return BoxDecoration(
      color: const Color(0xFF0078D4).withOpacity(0.1),
      border: Border.all(color: const Color(0xFF0078D4)),
    );
  }

  static BoxDecoration get hoverItemDecoration {
    return BoxDecoration(
      color: const Color(0xFFE1E1E1),
    );
  }
}