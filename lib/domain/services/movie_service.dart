import 'package:moviedb/configuration/configuration.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/domain/local_entity/movie_details_local.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(int page, String locale, String query) async =>
      _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);

  Future<MovieDetailLocal> loadDetails({required int movieId, required String locale}) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    bool isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
    return MovieDetailLocal(movieDetails: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({required int movieId, required bool isFavorite}) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (accountId == null || sessionId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: ApiClientMediaType.movie,
      mediaId: movieId,
      favorite: isFavorite,
    );
  }
}
