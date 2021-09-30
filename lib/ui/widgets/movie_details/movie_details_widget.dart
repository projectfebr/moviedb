import 'package:flutter/material.dart';
import 'package:moviedb/library/widgets/inherited/notifier_provider.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';

class MoveDetailsWidget extends StatefulWidget {
  const MoveDetailsWidget({Key? key}) : super(key: key);

  @override
  _MoveDetailsWidgetState createState() => _MoveDetailsWidgetState();
}

class _MoveDetailsWidgetState extends State<MoveDetailsWidget> {
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
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1.0),
        child: ListView(
          children: const [
            MovieDetailsMainInfoWidget(),
          ],
        ),
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
