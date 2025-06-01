import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../widgets/theme_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Настройки темы'),
              subtitle: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  String themeText;
                  switch (state.themeMode) {
                    case ThemeMode.light:
                      themeText = 'Светлая';
                      break;
                    case ThemeMode.dark:
                      themeText = 'Тёмная';
                      break;
                    default:
                      themeText = 'Системная';
                  }
                  return Text('Текущая тема: $themeText');
                },
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const ThemeDialog(),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}