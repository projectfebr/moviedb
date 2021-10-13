import 'package:flutter/material.dart';
import 'package:moviedb/domain/factories/screen_factory.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:moviedb/ui/widgets/movie_trailer/movie_trailer.dart';

class MainNavigationRouteNames {
  static const loader = '/';
  static const auth = '/auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/main_screen/movie_details';
  static const movieTrailer = '/main_screen/movie_details/trailer';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loader: (_) => _screenFactory.makeLoaderWidget(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuthWidget(),
    MainNavigationRouteNames.mainScreen: (_) =>
        _screenFactory.makeMainScreenWidget(),
  };

  // в onGenerateRoute можно проверять авторизован ли юзер. canPop() будет всегда true
  MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute<MoveDetailsWidget>(
          builder: (_) => _screenFactory.makeMovieDetailsWidget(movieId),
        );
      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute<MovieTrailerWidget>(
          builder: (_) => _screenFactory.makeMovieTrailer(youtubeKey),
        );
      default:
        const widget = Text('Navigation error!');
        return MaterialPageRoute<Widget>(builder: (_) => widget);
    }
  }
}
