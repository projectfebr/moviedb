import 'package:flutter/material.dart';
import 'package:moviedb/library/widgets/inherited/notifier_provider.dart' as old_provider;
import 'package:moviedb/ui/widgets/auth/auth_model.dart';
import 'package:moviedb/ui/widgets/auth/auth_widget.dart';
import 'package:moviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:moviedb/ui/widgets/loader/loader_widget.dart';
import 'package:moviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:moviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:moviedb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:moviedb/ui/widgets/movie_trailer/movie_trailer.dart';
import 'package:moviedb/ui/widgets/news/news_widget.dart';
import 'package:moviedb/ui/widgets/tv_show_list/tv_show_list_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoaderWidget() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false, // без false не будет работать, так как мы не нигде не обращаемся к модели
    );
  }

  Widget makeAuthWidget() {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreenWidget() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetailsWidget(int movieId) {
    return old_provider.NotifierProvider(
      create: () => MovieDetailsModel(movieId: movieId),
      child: const MoveDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(
      youtubeKey: youtubeKey,
    );
  }

  Widget makeNewsList() {
    return const NewsWidget();
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider<MovieListViewModel>(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVShowList() {
    return const TVShowListWidget();
  }
}
