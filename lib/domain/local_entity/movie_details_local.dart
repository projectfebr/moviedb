import 'package:moviedb/domain/entity/movie_details.dart';

class MovieDetailLocal {
  final MovieDetails movieDetails;
  final bool isFavorite;

  MovieDetailLocal({required this.movieDetails, required this.isFavorite});
}
