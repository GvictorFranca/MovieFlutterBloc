import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/casts_bloc.dart';
import 'package:movieChallengeStore/home/models/cast/cast_model.dart';
import 'package:movieChallengeStore/home/models/cast/cast_response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Style;

class Casts extends StatefulWidget {
  final int id;
  const Casts({
    Key key,
    this.id,
  }) : super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final CastsBloc castsBloc = GetIt.I.get();
  final int id;
  _CastsState(this.id);

  @override
  void initState() {
    castsBloc..getCasts(id);
    super.initState();
  }

  @override
  void dispose() {
    castsBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, top: 20),
          child: Text(
            "Atores",
            style: GoogleFonts.montserrat(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildCastsWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ],
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
Widget _buildCastsWidget(CastResponse data) {
  const urlImage = "https://image.tmdb.org/t/p/w300/";
  List<CastModel> casts = data.casts;

  return Container(
    height: 140,
    padding: EdgeInsets.only(left: 10),
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(top: 10, right: 8),
            width: 100,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  casts[index].img == null
                      ? Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      urlImage +
                                          casts[index].img))),
                        ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    casts[index].name.length > 10
                        ? casts[index].name.substring(0, 7) + '...'
                        : casts[index].name,
                    maxLines: 2,
                    style: GoogleFonts.montserrat(
                        height: 1.4,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    casts[index].character.length > 15
                        ? casts[index].character.substring(0, 9) + '...'
                        : casts[index].character,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          );
        }),
  );
}
