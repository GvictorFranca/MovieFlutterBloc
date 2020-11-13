import 'package:flutter/material.dart';
import 'package:movieChallengeStore/home/models/genre/genre_model.dart';
import 'package:movieChallengeStore/home/view/components/genre_movies.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieChallengeStore/home/view/style/theme.dart' as Color;

class GenresList extends StatefulWidget {
  final List<GenreModel> genres;
  const GenresList({
    Key key,
    @required this.genres,
  }) : super(key: key);

  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<GenreModel> genres;
  TabController _tabController;
  _GenresListState(this.genres);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Container(
        height: screenHeight,
        child: DefaultTabController(
            length: genres.length,
            child: Scaffold(
              appBar: PreferredSize(
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    bottom: TabBar(
                      controller: _tabController,
                          indicator: BoxDecoration(
                              color: Color.Colors.mainColor, 
                              borderRadius: BorderRadius.circular(20)
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      indicatorPadding: EdgeInsets.all(0),
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.white,
                      isScrollable: true,
                      tabs: genres.map((GenreModel genre) {
                        return Container(
                          width: 94,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(26),
                            color: Colors.transparent
                          ),
                          child: Center(
                            child: Text(
                            genre.name.length > 10
                           ? genre.name.substring(0, 6).toUpperCase() + '...' 
                           : genre.name.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                                ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  preferredSize: Size.fromHeight(40.0)),
              body: Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: genres.map((GenreModel genre) {
                      return GenreMovies(genreId: genre.id);
                    }).toList()),
              ),
            )),
      ),
    );
  }
}
