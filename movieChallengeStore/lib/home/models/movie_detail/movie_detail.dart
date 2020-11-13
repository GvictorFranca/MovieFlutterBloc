import 'package:movieChallengeStore/home/models/genre/genre_model.dart';

class MovieDetail {
  final int id;
  final bool adult;
  final int revenue;
  final List<GenreModel> genres;
  final String releaseDate;
  final int runtime;

  MovieDetail(this.id, this.adult, this.revenue, this.genres, this.releaseDate,
      this.runtime);

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        adult = json["adult"],
        revenue = json["revenue"],
        genres = (json["genres"] as List)
            .map((i) => GenreModel.fromJson(i))
            .toList(),
        releaseDate = json["release_date"],
        runtime = json["runtime"];
}
