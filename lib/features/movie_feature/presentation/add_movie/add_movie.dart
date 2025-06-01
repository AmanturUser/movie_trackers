import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/movie_model.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({Key? key}) : super(key: key);

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reviewController = TextEditingController();
  MovieStatus _selectedStatus = MovieStatus.planned;

  @override
  void dispose() {
    _titleController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _saveMovie() {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        status: _selectedStatus,
        review: _reviewController.text.trim(),
      );

      context.read<MovieBloc>().add(AddMovie(movie));
      // context.go('/');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить фильм'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
                // context.go('/')
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: ListView(
            children: [

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название фильма',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите название фильма';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Статус:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: RadioListTile<MovieStatus>(
                      title: Text(MovieStatus.planned.displayName),
                      value: MovieStatus.planned,
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<MovieStatus>(
                      title: Text(MovieStatus.watched.displayName),
                      value: MovieStatus.watched,
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: 'Отзыв',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите отзыв';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMovie,
                  child: const Text('Добавить фильм'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}