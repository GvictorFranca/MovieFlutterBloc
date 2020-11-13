import 'package:get_it/get_it.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:movieChallengeStore/application/blocs/movie_releated_bloc.dart';
import 'package:movieChallengeStore/home/models/movie/movie_model.dart';
import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/view/detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

class ReleatedMovies extends StatefulWidget {
  final int id;
  ReleatedMovies({Key key, @required this.id}) : super(key: key);
  @override
  _ReleatedMoviesState createState() => _ReleatedMoviesState(id);
}

class _ReleatedMoviesState extends State<ReleatedMovies> {
    final ReleatedMoviesBloc releatedMoviesBloc = GetIt.I.get();
  final int id;
  _ReleatedMoviesState(this.id);
  @override
  void initState() {
    super.initState();
    releatedMoviesBloc..getReleatedMovies(id);
  }
  @override
 void dispose() {
   releatedMoviesBloc..drainStream();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text("Filmes Relacionados", style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0
          ),),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieResponse>(
        stream: releatedMoviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildHomeWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        },
      )
      ],
    );
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
            valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
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
  
  Widget _buildHomeWidget(MovieResponse data) {
    List<MovieModel> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:1.0, top: 5),
                    child: Text(
                      "Sem filmes Relacionados",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    } else
      return Container(
        height: 270.0,
        padding: EdgeInsets.only(left: 12.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 15.0
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailPage(movie: movies[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                                BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3)
                             ),
                                  ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("https://image.tmdb.org/t/p/original" + movies[index].posterPath)),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                      movies[index].title.length > 10 ?
                      movies[index].title.substring(0,10) + '...' : 
                      movies[index].title,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(
                          height: 1.4,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                      color: Style.Colors.mainColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(movies[index].rating.toString(), style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold
                            ),),
                            SizedBox(
                              width: 5.0,
                            ),
                            RatingBar(
                          itemSize: 10.0,
                          initialRating: movies[index].rating / 2,
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
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}