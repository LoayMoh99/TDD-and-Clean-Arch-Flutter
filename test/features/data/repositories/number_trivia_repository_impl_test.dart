import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/exception.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/network/network_info.dart';
import 'package:number_trivia_app/features/data_layer/data_sources/number_trivia_local_datasource.dart';
import 'package:number_trivia_app/features/data_layer/data_sources/number_trivia_remote_datasource.dart';
import 'package:number_trivia_app/features/data_layer/models/number_trivia_model.dart';
import 'package:number_trivia_app/features/data_layer/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImplementation repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is Online..', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is Offline..', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online?',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    //now there will be two diff tests(subgroups) either device is Online or Offline..
    //////////////////ONLINE////////////////////
    runTestOnline(() {
      test(
        'should return remote data when the call to remote datasource is successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(
              result,
              equals(Right(
                  tNumberTrivia))); //why entity not model as result will be dealing with domain layer not data layer anymore..
        },
      );
      //now we need to make sure that we cached the data locally for Offline purposes..
      test(
        'should chace the data locally when the call to remote datasource is successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      //test server exception:
      test(
        'should return server exception when the call to remote datasource is un-successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    //////////////////OFFLINE////////////////////
    runTestOffline(() {
      test(
        'should return last cached data when the cached data is present..',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      //test cache exception:
      test(
        'should return cache exception when the cached data is not present..',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
///////////Now let's test random//////////////////
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online?',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    //now there will be two diff tests(subgroups) either device is Online or Offline..
    //////////////////ONLINE////////////////////
    runTestOnline(() {
      test(
        'should return remote data when the call to remote datasource is successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(
              result,
              equals(Right(
                  tNumberTrivia))); //why entity not model as result will be dealing with domain layer not data layer anymore..
        },
      );
      //now we need to make sure that we cached the data locally for Offline purposes..
      test(
        'should chace the data locally when the call to remote datasource is successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      //test server exception:
      test(
        'should return server exception when the call to remote datasource is un-successful..',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    //////////////////OFFLINE////////////////////
    runTestOffline(() {
      test(
        'should return last cached data when the cached data is present..',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
      //test cache exception:
      test(
        'should return cache exception when the cached data is not present..',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
