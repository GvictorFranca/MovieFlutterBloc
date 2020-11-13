import 'package:flutter/material.dart';
import 'package:movieChallengeStore/home/models/movie_detail/movie_detail_response.dart';
import 'package:movieChallengeStore/home/service/movie_service.dart';
import 'package:rxdart/subjects.dart';

class MovieDetailBloc {
  final MovieService _service;
  final BehaviorSubject<MovieDetailResponse> _subject =
      BehaviorSubject<MovieDetailResponse>();

  MovieDetailBloc(this._service);

  getMovieDetail(int id) async {
    MovieDetailResponse response = await _service.getMovieDetail(id);
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

  BehaviorSubject<MovieDetailResponse> get subject => _subject;
}


