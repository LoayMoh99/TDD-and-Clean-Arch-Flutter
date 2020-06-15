import 'package:dartz/dartz.dart';
import 'package:number_trivia_app/core/errors/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      int resultInt = int.parse(str);
      if (resultInt < 0)
        return throw FormatException();
      else
        return Right(resultInt);
    } on FormatException {
      return Left(InputConvertionFailure());
    }
  }
}

class InputConvertionFailure extends Failure {}
