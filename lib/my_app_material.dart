import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tracers/features/movie_feature/presentation/bloc/movie_bloc.dart';
import 'package:movie_tracers/features/movie_feature/presentation/bloc/movie_event.dart';
import 'core/services/firebase_service.dart';
import 'core/services/navigation_service.dart';
import 'core/theme/theme.dart';
import 'features/app_feature/presentation/bloc/app_bloc.dart';
import 'features/app_feature/presentation/bloc/app_event.dart';
import 'features/app_feature/presentation/bloc/app_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(FirebaseService())..add(LoadAppMode()),
        ),
        BlocProvider(create: (context) => MovieBloc()..add(LoadMovies())),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen:
            (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Movie Tracker',
            routerConfig: NavigationService.router.config(),
            theme: themeData,
            darkTheme: darkThemeData,
            themeMode: state.themeMode,
          );
        },
      ),
    );
  }
}
