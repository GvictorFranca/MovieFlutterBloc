import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/service/movie_service.dart';
import 'package:rxdart/subjects.dart';

class MoviesListByGenreBloc {
  final MovieService _service;
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  MoviesListByGenreBloc(this._service);

  getMoviesByGenre(int id) async {
    MovieResponse response = await _service.getMovieByGenre(id);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}


