import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/movie_detail_bloc.dart';
import 'package:movieChallengeStore/home/models/movie_detail/movie_detail.dart';
import 'package:movieChallengeStore/home/models/movie_detail/movie_detail_response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;


class GenreRowList extends StatefulWidget {
  final int id;

  const GenreRowList({Key key, this.id}) : super(key: key);

  @override
  _GenreRowListState createState() => _GenreRowListState(id);
}

class _GenreRowListState extends State<GenreRowList> {
  final MovieDetailBloc movieDetailBloc = GetIt.I.get();

  final int id;
  _GenreRowListState(this.id);

  @override
  void initState() {
    super.initState();
    movieDetailBloc..getMovieDetail(id);
  }

  @override
  void dispose() {
    super.dispose();
    movieDetailBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: movieDetailBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildRowGenreWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }
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

Widget _buildRowGenreWidget(MovieDetailResponse data) {
  MovieDetail detail = data.movieDetail;

  return Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15),
    child: Container(
      height: 38,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: detail.genres.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: 1, color: Colors.white)),
                child: Text(
                  detail.genres[index].name,
                  style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
              ),
            );
          }),
    ),
  );
}
