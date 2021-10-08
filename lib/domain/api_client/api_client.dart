import 'dart:convert';
import 'dart:io';

import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/domain/entity/movie_details.dart';
import 'package:moviedb/ui/widgets/auth/auth_model.dart';

class ApiClient {
  final _client = HttpClient();

  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '038971d5d5edcdd1dd72e951b29c9614';
  // https://api.themoviedb.org/3/movie/76341?api_key=<<api_key>>

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = await response.jsonDecode();

      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    final url = _makeUri(path, urlParameters);

    try {
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = await response.jsonDecode();

      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = await _get<String>(
      '/authentication/token/new',
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _post(
      '/authentication/token/validate_with_login',
      parameters,
      parser,
      <String, String>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };

    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final result = _post(
      '/authentication/session/new',
      parameters,
      parser,
      <String, String>{'api_key': _apiKey},
    );
    return result;
  }

// Запрос на получение списка популярных фильмов
  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final popularMovieResponse = PopularMovieResponse.fromJson(jsonMap);
      return popularMovieResponse;
    }

    final result = await _get<PopularMovieResponse>(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
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

    final result = await _get<PopularMovieResponse>(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': _apiKey,
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

    final result = await _get<MovieDetails>(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': _apiKey,
        'language': locale,
      },
    );
    return result;
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final int status = json['status_code'] as int;
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((value) => json.decode(value));
  }
}
