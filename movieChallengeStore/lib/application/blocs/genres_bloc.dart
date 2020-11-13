import 'package:movieChallengeStore/home/models/genre/genre_response.dart';
import 'package:movieChallengeStore/home/service/movie_service.dart';
import 'package:rxdart/subjects.dart';

class GenresListBloc {
  final MovieService _service;
  final BehaviorSubject<GenreResponse> _subject =
      BehaviorSubject<GenreResponse>();

  GenresListBloc(this._service);

  getGenres() async {
    GenreResponse response = await _service.getGenres();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;
}


