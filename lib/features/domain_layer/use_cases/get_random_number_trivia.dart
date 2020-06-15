import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../../core/usecases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/num_trivia_repo.dart';

class GetRandomNumberTrivia implements Usecases<NumberTrivia, NoParams> {
  final NumberTriviaRepository repo;

  GetRandomNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repo.getRandomNumberTrivia();
  }
}
