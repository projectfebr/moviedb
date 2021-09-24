import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void setupLocale({required BuildContext context}) {
    final locale = Localizations.localeOf(context);
    if (_locale == locale.toLanguageTag()) return;
    _locale = locale.toLanguageTag();
    _dateFormat = DateFormat.yMMMMd(_locale);
    _movies.clear();

    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final moviesResponse = await _apiClient.popularMovie(1, _locale);
    _movies.addAll(moviesResponse.movies);
    notifyListeners();
  }

  void onMovieTap({required BuildContext context, required int index}) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }
}
