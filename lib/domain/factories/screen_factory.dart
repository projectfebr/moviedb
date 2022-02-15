import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/blocs/auth_bloc.dart';
import 'package:moviedb/ui/widgets/auth/auth_view_cubit.dart';
import 'package:moviedb/ui/widgets/auth/auth_widget.dart';
import 'package:moviedb/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:moviedb/ui/widgets/loader_widget/loader_widget.dart';
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
  AuthBloc? _authBloc;

  Widget makeLoaderWidget() {
    final authBloc = _authBloc ?? AuthBloc(CheckAuthProgressState());
    _authBloc = _authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (_) => LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      child: const LoaderWidget(),
      lazy: false, // без false не будет работать, так как мы не нигде не обращаемся к модели
    );
  }

  Widget makeAuthWidget() {
    final authBloc = _authBloc ?? AuthBloc(AuthUnauthorizedState());
    _authBloc = _authBloc;
    return BlocProvider<AuthViewCubit>(
      create: (_) => AuthViewCubit(AuthViewCubitFormFillInProgressState(), authBloc),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreenWidget() {
    _authBloc?.close();
    _authBloc = null;
    return const MainScreenWidget();
  }

  Widget makeMovieDetailsWidget(int movieId) {
    return ChangeNotifierProvider(
      create: (context) => MovieDetailsModel(movieId: movieId),
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
