import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/entity/movie_details_credits.dart';
import 'package:moviedb/library/widgets/inherited/notifier_provider.dart';
import 'package:moviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:moviedb/ui/widgets/movie_details/movie_details_model.dart';

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
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>((context))?.movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage *= 10;

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
                    child: Text(voteAverage.toStringAsFixed(0)),
                    percent: voteAverage / 100,
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
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>((context))?.movieDetails;
    return Text(
      movieDetails?.overview ?? '',
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
    final model = NotifierProvider.watch<MovieDetailsModel>((context));
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
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
    final model = NotifierProvider.watch<MovieDetailsModel>((context));
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
            text: model?.movieDetails?.title ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
          ),
          TextSpan(
            text: year,
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
    final model = NotifierProvider.watch<MovieDetailsModel>((context));
    if (model == null) return const SizedBox.shrink();

    var texts = <String>[];

    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }

    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      final name = productionCountries.first.iso;
      texts.add(name);
    }

    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minuts = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minuts}m');

    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];

      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          texts.join(' '),
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
    final model = NotifierProvider.watch<MovieDetailsModel>((context));
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }

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
  final List<Employee> employes;
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
  final Employee employee;
  const _PeopleWidgetRowItem({Key? key, required this.employee})
      : super(key: key);

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
