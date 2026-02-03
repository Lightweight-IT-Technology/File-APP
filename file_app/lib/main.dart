import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/file_provider.dart';
import 'widgets/file_browser.dart';

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const FileBrowser(),
      ),
    );
  }
}
