import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:number_trivia_app/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CHACHED_NUMBER_TRIVIA = 'CHACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    // : implement getLastNumberTrivia
    final jsonString = sharedPreferences.getString(CHACHED_NUMBER_TRIVIA);
    //take care that shared prefrences is sync not async and we are expected to
    //return a Future<NumberTriviaModel> not NumberTriviaModel itself..
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  NumberTriviaLocalDatasourceImpl({@required this.sharedPreferences});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    // : implement cacheNumberTrivia
    final String stringValue = json.encode(triviaToCache.toJson());
    return sharedPreferences.setString(CHACHED_NUMBER_TRIVIA, stringValue);
  }
}
