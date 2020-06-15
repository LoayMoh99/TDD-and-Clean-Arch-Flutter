import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/features/data_layer/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

  test(
    'should be a subclass of NumberTrivia entity..',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is an integer number',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should return a valid model when the JSON is treated as a double number',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });

  group('toJson', () {
    test(
      'should return a jsonMap with the correct data..',
      () async {
        // arrange->already arragened for us by tNumberTriviaModel..
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "test",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
