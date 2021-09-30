import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  String _locale = '';
  late DateFormat _dateFormat;

  MovieDetails? _movieDetails;
  MovieDetails? get movieDetails => _movieDetails;

  MovieDetailsModel({required this.movieId});

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale({required BuildContext context}) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    await _loadDetails();
  }

  Future<void> _loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }
}
