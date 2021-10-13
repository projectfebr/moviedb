import 'package:moviedb/configuration/configuration.dart';
import 'package:moviedb/domain/api_client/network_client.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/domain/entity/movie_details.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

// Запрос на получение списка популярных фильмов
  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final popularMovieResponse = PopularMovieResponse.fromJson(jsonMap);
      return popularMovieResponse;
    }

    final result = await _networkClient.get<PopularMovieResponse>(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'language': locale,
        'page': page.toString(),
      },
    );
    return result;
  }

  // Запрос на получение списка популярных фильмов
  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final popularMovieResponse = PopularMovieResponse.fromJson(jsonMap);
      return popularMovieResponse;
    }

    final result = await _networkClient.get<PopularMovieResponse>(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'language': locale,
        'page': page.toString(),
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  // Запрос на получение информации о фильме
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final movieDetails = MovieDetails.fromJson(jsonMap);
      return movieDetails;
    }

    final result = await _networkClient.get<MovieDetails>(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = await _networkClient.get<bool>(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}
