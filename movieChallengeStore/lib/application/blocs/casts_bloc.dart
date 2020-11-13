import 'package:flutter/material.dart';
import 'package:movieChallengeStore/home/models/cast/cast_response.dart';
import 'package:movieChallengeStore/home/service/movie_service.dart';
import 'package:rxdart/subjects.dart';

class CastsBloc {
  final MovieService _service;
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();

  CastsBloc(this._service);

  getCasts(int id) async {
    CastResponse response = await _service.getCasts(id);
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

  BehaviorSubject<CastResponse> get subject => _subject;
}

