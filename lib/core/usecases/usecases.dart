//this help us to don't forget that all of our usecases need a call method..

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/core/errors/failure.dart';

abstract class Usecases<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

//and because maybe alot of testcases will have noparms so it is better to put it here..
class NoParams extends Equatable {}
