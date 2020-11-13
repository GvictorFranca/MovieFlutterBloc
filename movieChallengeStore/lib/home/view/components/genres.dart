import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/genres_bloc.dart';
import 'package:movieChallengeStore/home/models/genre/genre_model.dart';
import 'package:movieChallengeStore/home/models/genre/genre_response.dart';
import 'package:movieChallengeStore/home/view/components/genres_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final GenresListBloc genresBloc = GetIt.I.get();

  @override
  void initState() {
    super.initState();
    genresBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
        stream: genresBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildGenresWidget(snapshot.data);
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
    return Padding(
      padding: const EdgeInsets.only(top:200.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
      )),
    );
  }

  Widget _buildGenresWidget(GenreResponse data) {
    List<GenreModel> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        child: Text("Sem Generos"),
      );
    } else
      return GenresList(genres: genres);
  }
}
