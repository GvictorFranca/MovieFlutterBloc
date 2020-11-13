import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/movie_detail_bloc.dart';
import 'package:movieChallengeStore/application/blocs/movie_releated_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieChallengeStore/home/models/movie/movie_model.dart';
import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/view/components/casts.dart';
import 'package:movieChallengeStore/home/view/components/movie_info.dart';
import 'package:movieChallengeStore/home/view/components/releated_movies.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState(movie);
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieDetailBloc movieDetailBloc = GetIt.I.get();
  final ReleatedMoviesBloc releatedMoviesBloc = GetIt.I.get();
  
  final MovieModel movie;
  _MovieDetailPageState(this.movie);
  @override
  void initState() {
    super.initState();
    movieDetailBloc..getMovieDetail(movie.id);
  }

  @override
  void dispose() {
    movieDetailBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const posterPathUrl = 'https://image.tmdb.org/t/p/original';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(right: 20),
          floatingWidget: StreamBuilder<MovieResponse>(
            stream: releatedMoviesBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildEmpity(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return Container();
              }
            },
          ),
          expandedHeight: 200.0,
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context,'/');
                    })
              ],
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title.length > 29
                      ? movie.title.substring(0, 29) + '...'
                      : movie.title,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  posterPathUrl +
                                      movie.posterPath),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ])),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 100, right: 100),
                  child: Container(
                    height: 350,
                    width: 100,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              posterPathUrl +
                                  movie.posterPath),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100, top: 20, right: 100),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Style.Colors.mainColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                                SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            movie.rating.toString(),
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          RatingBar(
                            itemSize: 15.0,
                            initialRating: movie.rating / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 20,),
                  child: Text(
                    'Descrição',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left:15, right: 15),
                  child: Text(
                    movie.overview,
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontSize: 12, height: 1.5),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MovieInfo(id: movie.id),
                Casts(id: movie.id),
                ReleatedMovies(id: movie.id)
              ])),
            )
          ],
        );
      }),
    );
  }
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

Widget _buildEmpity(MovieResponse data) {
  return Text('');
}
