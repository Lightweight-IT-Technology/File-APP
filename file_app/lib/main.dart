import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/file_provider.dart';
import 'providers/settings_provider.dart';
import 'widgets/windows_file_browser_split.dart';
import 'theme/windows_theme.dart';
import 'services/window_opacity_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          // 应用窗口透明度设置
          _applyWindowOpacitySettings(settingsProvider);
          
          return MaterialApp(
            title: '文件资源管理器',
            theme: WindowsTheme.lightTheme,
            darkTheme: WindowsTheme.darkTheme,
            themeMode: settingsProvider.settings.themeMode,
            home: WindowOpacityProvider(
              manager: settingsProvider.windowOpacityManager,
              currentOpacity: settingsProvider.settings.windowOpacity,
              child: const WindowsFileBrowserSplit(),
            ),
          );
        },
      ),
    );
  }
  
  /// 应用窗口透明度设置
  static void _applyWindowOpacitySettings(SettingsProvider settingsProvider) {
    // 延迟应用窗口透明度设置，确保窗口已创建
    Future.delayed(const Duration(milliseconds: 100), () {
      settingsProvider.windowOpacityManager.setWindowOpacity(
        settingsProvider.settings.windowOpacity,
      );
    });
  }
}
