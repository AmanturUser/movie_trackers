import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tracers/features/movie_feature/presentation/add_movie/add_movie.dart';
import 'package:movie_tracers/features/movie_feature/presentation/settings/settings_screen.dart';
import '../../../core/const/form_status.dart';
import 'bloc/movie_bloc.dart';
import 'bloc/movie_event.dart';
import 'widgets/movie_card.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
              // context.go('/settings')
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        buildWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.statusAddMovie != current.statusAddMovie ||
                previous.statusUpdateMovie != current.statusUpdateMovie ||
                previous.statusDeleteMovie != current.statusDeleteMovie,
        builder: (context, state) {
          if (state.status == FormStatus.submissionInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FormStatus.submissionFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MovieBloc>().add(LoadMovies());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state.status == FormStatus.submissionSuccess) {
            final movies = state.movies;

            if (movies.isEmpty) {
              return const Center(
                child: Text('Нет фильмов. Добавьте первый фильм!'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: movies[index],
                  bloc: context.read<MovieBloc>(),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddMovieScreen(),
            ),
          );
          // context.go('/add-movie')
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
