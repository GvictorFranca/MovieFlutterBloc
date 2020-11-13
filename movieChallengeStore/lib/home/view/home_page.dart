import 'package:flutter/material.dart';
import 'package:movieChallengeStore/home/view/components/genres.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: Container(
              height: 40,
              width: 375,
              decoration: BoxDecoration(
                color: Color.fromRGBO(241,243,245,1),
                borderRadius: BorderRadius.circular(20),
              ),
              
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                          IconButton(
                        icon: FaIcon(FontAwesomeIcons.search,
                        size: 16,
                        color: Color.fromARGB(94,103,112,1),
                        ),
                        onPressed: () {
                        }),
                    Padding(
                      padding: const EdgeInsets.only(left:17.34),
                      child: Text("Pesquise filmes",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                                     fontSize: 17,
                          color: Colors.black38
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
        ),
        body: ListView(
    physics: NeverScrollableScrollPhysics(),
    children: <Widget>[
      GenresScreen()
    ],
        )
      );
  }
}
