import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/exception.dart';
import 'package:number_trivia_app/features/data_layer/data_sources/number_trivia_local_datasource.dart';
import 'package:number_trivia_app/features/data_layer/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../fixtures/fixture_reader.dart';

class MockSharedPrefrences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDatasourceImpl datasource;
  MockSharedPrefrences mockSharedPrefrences;

  setUp(() {
    mockSharedPrefrences = MockSharedPrefrences();
    datasource = NumberTriviaLocalDatasourceImpl(
        sharedPreferences: mockSharedPrefrences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_chached.json')));
    test(
      'should return the last NumberTrvia(model) from SharedPrefrences when it is existed in the cache',
      () async {
        // arrange
        when(mockSharedPrefrences.getString(any))
            .thenReturn(fixture('trivia_chached.json'));
        // act
        final result = await datasource.getLastNumberTrivia();
        // assert
        verify(mockSharedPrefrences.getString(CHACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throm Chached expection when no cache existed in shared pref (case of first launch to the app)',
      () async {
        // arrange
        when(mockSharedPrefrences.getString(any)).thenReturn(null);
        // act
        final call = datasource.getLastNumberTrivia;
        // assert
        //when this call is called from upper level func it throws CacheExeption..
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('chacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
    test(
      'should call SharedPrefrences to cache the data',
      () async {
        // act
        datasource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        //value of setString is the string representation of tNumberTriviaModel:
        final String stringValue = json.encode(tNumberTriviaModel.toJson());
        verify(
            mockSharedPrefrences.setString(CHACHED_NUMBER_TRIVIA, stringValue));
      },
    );
  });
}
