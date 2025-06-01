part of 'movie_bloc.dart';

class MovieState extends Equatable {
  const MovieState({
    this.status = FormStatus.pure,
    this.statusDeleteMovie = FormStatus.pure,
    this.statusAddMovie = FormStatus.pure,
    this.statusUpdateMovie = FormStatus.pure,
    this.movies = const [],
    this.error = '',
    this.themeMode = ThemeMode.system,
  });

  final FormStatus status;
  final FormStatus statusDeleteMovie;
  final FormStatus statusAddMovie;
  final FormStatus statusUpdateMovie;
  final List<Movie> movies;
  final String error;
  final ThemeMode themeMode;

  MovieState copyWith({
    FormStatus? status,
    FormStatus? statusDeleteMovie,
    FormStatus? statusAddMovie,
    FormStatus? statusUpdateMovie,
    List<Movie>? movies,
    String? error,
    ThemeMode? themeMode,
  }) {
    return MovieState(
      status: status ?? this.status,
      statusDeleteMovie: statusDeleteMovie ?? this.statusDeleteMovie,
      statusAddMovie: statusAddMovie ?? this.statusAddMovie,
      statusUpdateMovie: statusUpdateMovie ?? this.statusUpdateMovie,
      movies: movies ?? this.movies,
      error: error ?? this.error,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [
    status,
    statusDeleteMovie,
    statusAddMovie,
    statusUpdateMovie,
    movies,
    themeMode,
    error
  ];
}
