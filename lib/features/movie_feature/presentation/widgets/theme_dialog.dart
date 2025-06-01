import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_feature/presentation/bloc/app_bloc.dart';
import '../../../app_feature/presentation/bloc/app_event.dart';
import '../../../app_feature/presentation/bloc/app_state.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Выбор темы'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Светлая'),
                value: ThemeMode.light,
                groupValue: state.themeMode,
                onChanged: (value) {
                  context.read<AppBloc>().add(ChangeTheme(value!));
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Тёмная'),
                value: ThemeMode.dark,
                groupValue: state.themeMode,
                onChanged: (value) {
                  context.read<AppBloc>().add(ChangeTheme(value!));
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Системная'),
                value: ThemeMode.system,
                groupValue: state.themeMode,
                onChanged: (value) {
                  context.read<AppBloc>().add(ChangeTheme(value!));
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}