import 'package:flutter/material.dart';
import 'package:moviedb/resources/resources.dart';
import 'package:moviedb/ui/widgets/elements/radial_percent_widget.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _MovieNameWidget(),
        ),
        _SummaryWidget(),
        _ScoreWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverwievWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 30),
        _PeopleWidget(),
      ],
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: const [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RadialPercentWidget(
                    child: Text('72'),
                    percent: 0.72,
                    fillColor: Color.fromARGB(255, 10, 23, 45),
                    lineColor: Color.fromARGB(255, 37, 203, 103),
                    freeColor: Color.fromARGB(255, 25, 54, 31),
                    lineWidth: 3,
                  ),
                ),
                SizedBox(width: 10),
                Text('User Score'),
              ],
            )),
        Container(
          color: Colors.grey,
          width: 1,
          height: 15,
        ),
        TextButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                Text('Play Trailer'),
              ],
            )),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Description Description Description Description Description Description Description Description Description Description Description',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

class _OverwievWidget extends StatelessWidget {
  const _OverwievWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Overwiev',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Image(image: AssetImage(AppImages.top_header)),
        Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Image(image: AssetImage(AppImages.top_header_sub_image))),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 3,
      text: TextSpan(children: const [
        TextSpan(
          text: 'Tom Clancy without remote fgdfg dfgdgd dfgdg ',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
        ),
        TextSpan(
          text: ' (2021)',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ]),
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Text(
          'R 04/29/2021 (US) Action, Adventure, Thriller, War',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 16,
    );
    final jobTitleStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 16,
    );
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crwedf SDsdfd',
                  style: nameStyle,
                ),
                Text(
                  'Director',
                  style: jobTitleStyle,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crwe SDsdsdfd', style: nameStyle),
                Text(
                  'Producer',
                  style: jobTitleStyle,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crwedf SDsdfd',
                  style: nameStyle,
                ),
                Text(
                  'Director',
                  style: jobTitleStyle,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crwe SDsdsdfd', style: nameStyle),
                Text(
                  'Producer',
                  style: jobTitleStyle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
