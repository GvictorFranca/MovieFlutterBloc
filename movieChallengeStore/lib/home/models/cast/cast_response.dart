import 'package:movieChallengeStore/home/models/cast/cast_model.dart';

class CastResponse {
  final List<CastModel> casts;
  final String error;

  CastResponse(this.casts, this.error);

  CastResponse.fromJson(Map<String, dynamic> json)
      : casts =
            (json["cast"] as List).map((i) => CastModel.fromJson(i)).toList(),
        error = "";

  CastResponse.withError(String errorValue)
      : casts = List(),
        error = errorValue;
}

