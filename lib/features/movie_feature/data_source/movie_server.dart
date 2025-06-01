import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:movie_tracers/features/movie_feature/domain/movie_model.dart';

Future<List<Movie>> getMovies() async {
  var data = await rootBundle.loadString("assets/movies.json");
  var decodeData=jsonDecode(data);
  List<Movie> movies = [];
  for(var item in decodeData){
    movies.add(Movie.fromJson(item));
  }
  return movies;
}