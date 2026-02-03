import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/file_provider.dart';
import 'widgets/windows_file_browser_split.dart';
import 'theme/windows_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FileProvider(),
      child: MaterialApp(
        title: '文件资源管理器',
        theme: WindowsTheme.lightTheme,
        darkTheme: WindowsTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const WindowsFileBrowserSplit(),
      ),
    );
  }
}
