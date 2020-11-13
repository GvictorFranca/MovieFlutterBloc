import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/movies_by_genre.dart';
import 'package:movieChallengeStore/home/models/movie/movie_model.dart';
import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/view/components/genres_row_list.dart';
import 'package:movieChallengeStore/home/view/detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

class GenreMovies extends StatefulWidget {
  final int genreId;
  const GenreMovies({
    Key key,
    @required this.genreId,
  }) : super(key: key);

  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final MoviesListByGenreBloc moviesByGenreBloc = GetIt.I.get();
  final int genreId;
  _GenreMoviesState(this.genreId);
  @override
  void initState() {
    super.initState();
    moviesByGenreBloc..getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
        stream: moviesByGenreBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildMoviesByGenreWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    print(error);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Container(
          height: 80,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Style.Colors.mainColor),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text("Ocorreu um erro, tente novamente",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white
              ),
              ),
            ),
          ),
        )
      ],
    ));
  }
  
  Widget _buildMoviesByGenreWidget(MovieResponse data) {
    List<MovieModel> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        child: Text("No Movies"),
      );
    } else
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10.0),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailPage(movie: movies[index])));
                  },
                  child: Column(
                    children: <Widget>[
                      movies[index].posterPath == null
                          ? Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  borderRadius: BorderRadius.circular(20),
                                  shape: BoxShape.rectangle),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.ac_unit_sharp,
                                    color: Colors.yellow,
                                    size: 50.0,
                                  )
                                ],
                              ),
                            )
                          : Stack(alignment: Alignment.center, children: [
                              Container(
                                width: 375.0,
                                height: 500.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.darken),
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/original' +
                                                movies[index].posterPath),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                top: 290,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 190,
                                      width: 375,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: Text(
                                              movies[index].title.length > 25
                                                  ? movies[index]
                                                          .title
                                                          .substring(0, 25) +
                                                      '...'
                                                  : movies[index].title,
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Gêneros",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          SizedBox(height: 15),
                                          Center(
                                              child: GenreRowList(
                                                  id: movies[index].id))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                    ],
                  ),
                ),
              );
            }),
      );
  }
}
