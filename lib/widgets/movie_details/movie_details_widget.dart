import 'package:flutter/material.dart';
import 'package:moviedb/widgets/movie_details/movie_details_main_info_widget.dart';

class MoveDetailsWidget extends StatefulWidget {
  final int movieId;
  MoveDetailsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  _MoveDetailsWidgetState createState() => _MoveDetailsWidgetState();
}

class _MoveDetailsWidgetState extends State<MoveDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucifer'),
      ),
      body: ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: ListView(
          children: [
            MovieDetailsMainInfoWidget(),
          ],
        ),
      ),
    );
  }
}
