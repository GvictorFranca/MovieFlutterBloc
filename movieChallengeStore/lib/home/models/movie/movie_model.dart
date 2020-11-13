

class MovieModel {
  final int id;
  final String posterPath;
  final String title;
  final String originalTitle;
  final String overview;
  final double rating;
  final double popularity;

  MovieModel({
    this.id,
    this.posterPath,
    this.title,
    this.originalTitle,
    this.overview,
    this.rating,
    this.popularity,
  });

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        popularity = json["popularity"],
        title = json["title"],
        originalTitle = json["original_title"],
        posterPath = json["poster_path"],
        overview = json["overview"],
        rating = json["vote_average"].toDouble();
}
