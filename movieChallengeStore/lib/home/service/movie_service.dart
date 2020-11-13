import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieChallengeStore/home/models/cast/cast_response.dart';
import 'package:movieChallengeStore/home/models/genre/genre_response.dart';
import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/models/movie_detail/movie_detail_response.dart';




class MovieService {
  final Dio _dio = Dio();

  final apiKey = DotEnv().env['API_KEY'];
  final lang = DotEnv().env['LANG'];
  static String mainUrl = 'https://api.themoviedb.org/3';



  var getMoviesUrl = '$mainUrl/discover/movie';
  var getGenresUrl = '$mainUrl/genre/movie/list';
  var getPesonsUrl = '$mainUrl/trending/person/week';
  var movieUrl = '$mainUrl/movie';


  Future<GenreResponse> getGenres() async {
    var params = {"api_key": apiKey, "lang": lang, "page": 1};

    try {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception : $error stackTrace: $stackTrace");
      return GenreResponse.withError('$error');
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": apiKey,
      "lang": lang,
      "page": 1,
      "with_genres": id
    };

    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception : $error stackTrace: $stackTrace");
      return MovieResponse.withError('$error');
    }
  }


  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {"api_key": apiKey, "language": lang};

    try {
      Response response =
          await _dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception : $error stackTrace: $stackTrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {"api_key": apiKey, "language": lang};

    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/credits",
          queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception : $error stackTrace: $stackTrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieResponse> getReleatedMovies(int id) async {
    var params = {"api_key": apiKey, "language": lang};

    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/similar",
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Exception : $error stackTrace: $stackTrace");
      return MovieResponse.withError("$error");
    }
  }
}
