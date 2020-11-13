import 'package:flutter/material.dart';
import 'package:movieChallengeStore/home/models/movie/movie_response.dart';
import 'package:movieChallengeStore/home/service/movie_service.dart';
import 'package:rxdart/subjects.dart';

class ReleatedMoviesBloc {
  final MovieService _service;
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  ReleatedMoviesBloc(this._service);

  getReleatedMovies(int id) async {
    MovieResponse response = await _service.getReleatedMovies(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}


