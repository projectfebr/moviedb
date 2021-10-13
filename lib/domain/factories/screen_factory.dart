import 'package:flutter/material.dart';
import 'package:moviedb/library/widgets/inherited/notifier_provider.dart'
    as old_provider;
import 'package:moviedb/ui/widgets/auth/auth_model.dart';
import 'package:moviedb/ui/widgets/auth/auth_widget.dart';
import 'package:moviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:moviedb/ui/widgets/loader/loader_widget.dart';
import 'package:moviedb/ui/widgets/main_screen/main_screen_model.dart';
import 'package:moviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:moviedb/ui/widgets/movie_trailer/movie_trailer.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoaderWidget() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy:
          false, // без false не будет работать, так как мы не нигде не обращаемся к модели
    );
  }

  Widget makeAuthWidget() {
    return old_provider.NotifierProvider<AuthModel>(
      create: () => AuthModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreenWidget() {
    return old_provider.NotifierProvider(
      create: () => MainScreenModel(),
      child: const MainScreenWidget(),
    );
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
}
