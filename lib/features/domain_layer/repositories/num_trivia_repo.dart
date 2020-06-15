import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  //either is a functional programming style; which help in recieving a future of "either" values..
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
