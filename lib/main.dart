import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vibe/logic/app_cubit/app_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/dependency_injection.dart';
import 'core/handlers/app_bloc_observer.dart';
import 'core/handlers/song_handler.dart';
import 'core/theming/app_themes.dart';
import 'logic/app_cubit/app_state.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/permissions_screen.dart';

bool _hasPermission = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
  await getIt<MyAudioHandler>().restoreAudioState();
  _hasPermission = await getIt<OnAudioQuery>().permissionsStatus();
  Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppCubit(sharedPreferences: getIt<SharedPreferences>()),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return MaterialApp(
            title: 'Music Vibe',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: context.read<AppCubit>().isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home:
                _hasPermission ? const HomeScreen() : const PermissionsScreen(),
          );
        },
      ),
    );
  }
}
