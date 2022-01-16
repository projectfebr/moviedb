import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/ui/navigation/main_navigation.dart';
import 'package:moviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreData = context.select((MovieDetailsModel model) => model.data.scoreData);
    final trailerKey = scoreData.trailerKey;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RadialPercentWidget(
                    child: Text(scoreData.voteAverage.toStringAsFixed(0)),
                    percent: scoreData.voteAverage / 100,
                    fillColor: const Color.fromARGB(255, 10, 23, 45),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineWidth: 3,
                  ),
                ),
                const SizedBox(width: 10),
                const Text('User Score'),
              ],
            )),
        Container(
          color: Colors.grey,
          width: 1,
          height: 15,
        ),
        if (trailerKey != null)
          TextButton(
            onPressed: () {
              //функцию лучше вынести в модель
              Navigator.of(context)
                  .pushNamed(MainNavigationRouteNames.movieTrailer, arguments: trailerKey);
            },
            child: Row(
              children: const [
                Icon(Icons.play_arrow),
                Text('Play Trailer'),
              ],
            ),
          ),
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
    final overview = context.select((MovieDetailsModel model) => model.data.overview);
    return Text(
      overview,
      style: const TextStyle(
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
    return const Text(
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
    final model = context.read<MovieDetailsModel>();
    final posterData = context.select((MovieDetailsModel model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    final favoriteIcon = posterData.favoriteIcon;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(
              ImageDownloader.imageUrl(backdropPath),
            ),
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(
                ImageDownloader.imageUrl(posterPath),
              ),
            ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(
                favoriteIcon,
                color: Colors.redAccent,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameData = context.select((MovieDetailsModel model) => model.data.nameData);

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
            text: nameData.name,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
          ),
          TextSpan(
            text: nameData.year,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ]),
      ),
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = context.select((MovieDetailsModel model) => model.data.summary);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          summary,
          textAlign: TextAlign.center,
          style: const TextStyle(
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
    var crewChunks = context.select((MovieDetailsModel model) => model.data.peopleData);

    if (crewChunks.isEmpty) return const SizedBox.shrink();
    return Column(
      children: crewChunks
          .map(
            (chunk) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _PeopleWidgetRow(
                employes: chunk,
              ),
            ),
          )
          .toList(),
      // _PeopleWidgetRow(),
      // const SizedBox(height: 20),
      // _PeopleWidgetRow(),
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<MovieDetailsMoviePeopleData> employes;

  const _PeopleWidgetRow({Key? key, required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: employes
          .map(
            (e) => _PeopleWidgetRowItem(employee: e),
          )
          .toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final MovieDetailsMoviePeopleData employee;

  const _PeopleWidgetRowItem({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 16,
    );
    const jobTitleStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 16,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobTitleStyle),
        ],
      ),
    );
  }
}
