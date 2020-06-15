import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia_app/core/errors/exception.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/network_info.dart';
import '../../domain_layer/entities/number_trivia.dart';
import '../../domain_layer/repositories/num_trivia_repo.dart';
import '../data_sources/number_trivia_local_datasource.dart';
import '../data_sources/number_trivia_remote_datasource.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    // : implement getConcreteNumberTrivia
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    // : implement getRandomNumberTrivia
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  //and as you can both method is exactly the same except for one line of code;so to solve it:
  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //if offline
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
