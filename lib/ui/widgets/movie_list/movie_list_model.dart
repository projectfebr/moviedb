import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];

  String _locale = '';
  late int _currentPage;
  late int _totalPage;
  bool _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? _searchDebounce;

  late DateFormat _dateFormat;
  List<Movie> get movies => List.unmodifiable(_movies);

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale({required BuildContext context}) async {
    final locale = Localizations.localeOf(context);
    if (_locale == locale.toLanguageTag()) return;
    _locale = locale.toLanguageTag();
    _dateFormat = DateFormat.yMMMMd(_locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await _loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularMovie(nextPage, locale);
    } else {
      return await _apiClient.searchMovie(nextPage, locale, query.trim());
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final moviesResponse = await _loadMovies(nextPage, _locale);
      _movies.addAll(moviesResponse.movies);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _movies.addAll(moviesResponse.movies);
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  void onMovieTap({required BuildContext context, required int index}) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> searchMovie(String text) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (searchQuery == _searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < movies.length - 1) return;
    _loadNextPage();
  }
}
