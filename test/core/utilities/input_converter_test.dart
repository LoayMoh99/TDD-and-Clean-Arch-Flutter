import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/core/utilities/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // arrange
        final str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return a failure when the str isn\'t int (i.e. double,str,..)',
      () async {
        // arrange
        final str = '1.2';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InputConvertionFailure()));
      },
    );

    test(
      'should return a failure when the str i a negative integer',
      () async {
        // arrange
        final str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InputConvertionFailure()));
      },
    );
  });
}
