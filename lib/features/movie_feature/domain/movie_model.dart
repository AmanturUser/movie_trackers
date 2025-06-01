import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final MovieStatus status;
  final String review;

  const Movie({
    required this.id,
    required this.title,
    required this.status,
    required this.review,
  });

  // JSON сериализация
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      status: MovieStatus.fromString(json['status'] as String),
      review: json['review'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status.name,
      'review': review,
    };
  }

  Movie copyWith({
    String? id,
    String? title,
    MovieStatus? status,
    String? review,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      review: review ?? this.review,
    );
  }

  @override
  List<Object> get props => [id, title, status, review];
}

enum MovieStatus {
  watched('Просмотрен'),
  planned('В планах');

  const MovieStatus(this.displayName);
  final String displayName;

  // Получение enum из строки
  static MovieStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'watched':
        return MovieStatus.watched;
      case 'planned':
        return MovieStatus.planned;
      default:
        return MovieStatus.planned;
    }
  }
}