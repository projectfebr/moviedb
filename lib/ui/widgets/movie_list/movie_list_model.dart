import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/services/movie_service.dart';
import 'package:moviedb/library/localized_model.dart';
import 'package:moviedb/library/paginator.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';

class MovieListRowData {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String releaseDate;

  MovieListRowData({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    this.posterPath,
  });
}

class MovieListViewModel extends ChangeNotifier {
  var _movies = <MovieListRowData>[];
  final _movieService = MovieService();
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;

  final _localeStorage = LocalizedModelStorage();
  String? _searchQuery;
  Timer? _searchDebounce;

  late DateFormat _dateFormat;

  List<MovieListRowData> get movies => List.unmodifiable(_movies);

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieListViewModel() {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result = await _movieService.popularMovie(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies, currentPage: result.page, totalPage: result.totalPages);
    });

    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await _movieService.searchMovie(page, _localeStorage.localeTag, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies, currentPage: result.page, totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale({required Locale locale}) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle = releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      releaseDate: releaseDateTitle,
    );
  }

  void onMovieTap({required BuildContext context, required int index}) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> searchMovie(String text) async {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (searchQuery == _searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < movies.length - 1) return;
    _loadNextPage();
  }
}
