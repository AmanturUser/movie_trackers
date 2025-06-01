import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/movie_model.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {}


class AddMovie extends MovieEvent {
  final Movie movie;

  const AddMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

class UpdateMovie extends MovieEvent {
  final Movie movie;

  const UpdateMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

class DeleteMovie extends MovieEvent {
  final String movieId;

  const DeleteMovie(this.movieId);

  @override
  List<Object> get props => [movieId];
}