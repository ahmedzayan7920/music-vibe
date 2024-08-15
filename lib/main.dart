import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'handlers/dependency_injection.dart';
import 'handlers/song_handler.dart';
import 'theming/app_themes.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/permissions_screen.dart';

bool _hasPermission = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
  await getIt<MyAudioHandler>().restoreAudioState();
  _hasPermission = await getIt<OnAudioQuery>().permissionsStatus();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.light,
      home: _hasPermission ? const HomeScreen() : const PermissionsScreen(),
    );
  }
}
