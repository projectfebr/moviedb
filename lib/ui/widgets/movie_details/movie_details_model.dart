import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/api_client_exception.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/movie_details.dart';
import 'package:moviedb/domain/services/auth_service.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class MovieDetailsMoviePosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;

  IconData get favoriteIcon => isFavorite ? Icons.favorite : Icons.favorite_outline;

  MovieDetailsMoviePosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsMoviePosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsMoviePosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String name;
  final String year;

  MovieDetailsMovieNameData({required this.name, required this.year});
}

class MovieDetailsMovieScoreData {
  final double voteAverage;
  final String? trailerKey;

  MovieDetailsMovieScoreData({required this.voteAverage, this.trailerKey});
}

class MovieDetailsMoviePeopleData {
  final String job;
  final String name;

  MovieDetailsMoviePeopleData({required this.job, required this.name});
}

class MovieDetailsMovieActorData {
  final String name;
  final String character;
  final String? profilePath;

  MovieDetailsMovieActorData({required this.name, required this.character, this.profilePath});
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsMoviePosterData posterData = MovieDetailsMoviePosterData();
  MovieDetailsMovieNameData nameData = MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsMovieScoreData scoreData = MovieDetailsMovieScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsMoviePeopleData>> peopleData = const <List<MovieDetailsMoviePeopleData>>[];
  List<MovieDetailsMovieActorData> actorsData = const <MovieDetailsMovieActorData>[];
}

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();

  final int movieId;
  final data = MovieDetailsData();
  String _locale = '';
  late DateFormat _dateFormat;

  MovieDetailsModel({required this.movieId});

  Future<void> setupLocale({required BuildContext context}) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    updateData(null, false);
    await _loadDetails(context);
  }

  Future<void> _loadDetails(BuildContext context) async {
    try {
      final movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      bool isFavorite = false;
      if (sessionId != null) {
        isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      }
      updateData(movieDetails, isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Загрузка...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.posterData = MovieDetailsMoviePosterData(
      isFavorite: isFavorite,
      posterPath: details.posterPath,
      backdropPath: details.backdropPath,
    );

    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);

    var voteAverage = details.voteAverage;
    voteAverage *= 10;
    final videos =
        details.videos.results.where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.scoreData = MovieDetailsMovieScoreData(voteAverage: voteAverage, trailerKey: trailerKey);
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.actorsData = details.credits.cast
        .map((e) => MovieDetailsMovieActorData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();
    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];

    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    final productionCountries = details.productionCountries;
    if (productionCountries.isNotEmpty) {
      final name = productionCountries.first.iso;
      texts.add(name);
    }

    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');

    final genres = details.genres;
    if (genres.isNotEmpty) {
      var genresNames = <String>[];

      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(' ');
  }

  List<List<MovieDetailsMoviePeopleData>> makePeopleData(MovieDetails details) {
    var crew = details.credits.crew
        .map((e) => MovieDetailsMoviePeopleData(job: e.job, name: e.name))
        .toList();
    if (crew.isEmpty) return const <List<MovieDetailsMoviePeopleData>>[];
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsMoviePeopleData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChunks;
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (accountId == null || sessionId == null) return;

    final isFavorite = !data.posterData.isFavorite;
    data.posterData = data.posterData.copyWith(isFavorite: isFavorite);
    notifyListeners();
    try {
      await _accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: ApiClientMediaType.movie,
        mediaId: movieId,
        favorite: isFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigator.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
