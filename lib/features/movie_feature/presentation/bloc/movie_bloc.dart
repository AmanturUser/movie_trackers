import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/const/form_status.dart';
import '../../data_source/movie_server.dart';
import '../../domain/movie_model.dart';
import 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(const MovieState()) {
    on<LoadMovies>(_loadMovies);
    on<UpdateMovie>(_updateMovie);
    on<DeleteMovie>(_deleteMovie);
    on<AddMovie>(_addMovie);
  }

  _loadMovies(LoadMovies event, Emitter emit) async {
    emit(state.copyWith(status: FormStatus.submissionInProgress));
    try {
      final movies = await getMovies();
      emit(state.copyWith(status: FormStatus.submissionSuccess, movies: movies));
    } catch (e) {
      emit(state.copyWith(status: FormStatus.submissionFailure));
    }
  }



  _deleteMovie(DeleteMovie event, Emitter emit) async {
    emit(state.copyWith(statusDeleteMovie: FormStatus.submissionInProgress));
    try {
      List<Movie> movies = state.movies;
      movies.removeWhere((item) => item.id == event.movieId);
      emit(state.copyWith(statusDeleteMovie: FormStatus.submissionSuccess, movies: movies));
    } catch (e) {
      emit(state.copyWith(statusDeleteMovie: FormStatus.submissionFailure));
    }
  }

  _updateMovie(UpdateMovie event, Emitter emit) async {
    emit(state.copyWith(statusUpdateMovie: FormStatus.submissionInProgress));
    try {
      final movies = state.movies.map( (item) {
        if(item.id == event.movie.id){
          return event.movie;
        }
        return item;
      }).toList();
      emit(state.copyWith(statusUpdateMovie: FormStatus.submissionSuccess, movies: movies));
    } catch (e) {
      emit(state.copyWith(statusUpdateMovie: FormStatus.submissionFailure));
    }
  }

  _addMovie(AddMovie event, Emitter emit) async {
    emit(state.copyWith(statusAddMovie: FormStatus.submissionInProgress));
    try {
      emit(state.copyWith(statusAddMovie: FormStatus.submissionSuccess, movies: [event.movie ,...state.movies]));
    } catch (e) {
      emit(state.copyWith(statusAddMovie: FormStatus.submissionFailure));
    }
  }
}
