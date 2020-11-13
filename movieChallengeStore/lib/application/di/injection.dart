import 'package:get_it/get_it.dart';
import 'package:movieChallengeStore/application/blocs/casts_bloc.dart';
import 'package:movieChallengeStore/application/blocs/genres_bloc.dart';
import 'package:movieChallengeStore/application/blocs/movie_detail_bloc.dart';
import 'package:movieChallengeStore/application/blocs/movie_releated_bloc.dart';
import 'package:movieChallengeStore/application/blocs/movies_by_genre.dart';

import 'package:movieChallengeStore/home/service/movie_service.dart';

class Injection {
  static final _getIt = GetIt.instance;

  static void init() {
    _getIt.registerFactory<MovieService>(() => MovieService());
    _getIt.registerFactory<CastsBloc>(() => CastsBloc(_getIt.get()));
    _getIt.registerFactory<GenresListBloc>(() => GenresListBloc(_getIt.get()));
    _getIt.registerFactory<MovieDetailBloc>(() => MovieDetailBloc(_getIt.get()));
    _getIt.registerFactory<ReleatedMoviesBloc>(() => ReleatedMoviesBloc(_getIt.get()));
    _getIt.registerFactory<MoviesListByGenreBloc>(() => MoviesListByGenreBloc(_getIt.get()));
  }
}


