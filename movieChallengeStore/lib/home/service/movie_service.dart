import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieChallengeStore/home/helpers/movies_exception.dart';
import 'package:movieChallengeStore/home/models/movie_model.dart';
import 'package:movieChallengeStore/home/models/paginationFilter.dart';

class MovieService {
  final Dio _dio;

  MovieService(this._dio);

  Future<List<MovieModel>> getMovies(PaginationFilter filter) async {
    final apiKey = DotEnv().env['API_KEY'];
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/discover/movie?with_genres=12&api_key=${apiKey}&language=en-US&page=${filter.page}');
      print(response);
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<MovieModel> movies = results
          .map((movieData) => MovieModel.fromMap(movieData))
          .toList(growable: false);

      return movies;
    } on DioError catch (dioError) {
      throw MoviesException.fromDioError(dioError);
    }
  }
}
