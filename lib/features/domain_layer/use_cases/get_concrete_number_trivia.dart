import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/usecases/usecases.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';

import '../repositories/num_trivia_repo.dart';

class GetConcreteNumberTrivia implements Usecases<NumberTrivia, Params> {
  final NumberTriviaRepository repo;

  GetConcreteNumberTrivia(this.repo);
  //usecases always need a call method..
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repo.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number; //which is the only paramter we need in this test case..

  Params({this.number}) : super([number]);
}
