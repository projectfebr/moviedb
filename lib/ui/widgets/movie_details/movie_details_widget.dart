import 'package:flutter/material.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

class MoveDetailsWidget extends StatefulWidget {
  const MoveDetailsWidget({Key? key}) : super(key: key);

  @override
  _MoveDetailsWidgetState createState() => _MoveDetailsWidgetState();
}

class _MoveDetailsWidgetState extends State<MoveDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    Future.microtask(
        () => context.read<MovieDetailsModel>().setupLocale(context: context, locale: locale));
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
    final title = context.select((MovieDetailsModel model) => model.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((MovieDetailsModel model) => model.data.isLoading);
    if (isLoading) {
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
