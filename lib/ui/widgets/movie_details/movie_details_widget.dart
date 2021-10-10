import 'package:flutter/material.dart';
import 'package:moviedb/library/widgets/inherited/notifier_provider.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:moviedb/ui/widgets/my_app.dart/my_app_model.dart';

class MoveDetailsWidget extends StatefulWidget {
  const MoveDetailsWidget({Key? key}) : super(key: key);

  @override
  _MoveDetailsWidgetState createState() => _MoveDetailsWidgetState();
}

class _MoveDetailsWidgetState extends State<MoveDetailsWidget> {
  @override
  void initState() {
    super.initState();
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final appModel = Provider.read<MyAppModel>(context);
    model?.sessionExpired = () => appModel?.resetSession(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<MovieDetailsModel>(context)
        ?.setupLocale(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(model?.movieDetails?.title ?? 'Загрузка');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>((context));
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30),
        MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}
