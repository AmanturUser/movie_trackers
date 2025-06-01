import 'package:flutter/material.dart';
import 'package:movie_tracers/features/movie_feature/presentation/bloc/movie_event.dart';

import '../../domain/movie_model.dart';
import '../bloc/movie_bloc.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final MovieBloc bloc;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.bloc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: (){},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(onPressed: (){
                    bloc.add(DeleteMovie(movie.id));
                  }, icon: Icon(Icons.delete, color: Colors.red,))
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: movie.status == MovieStatus.watched
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  movie.status.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.review,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}