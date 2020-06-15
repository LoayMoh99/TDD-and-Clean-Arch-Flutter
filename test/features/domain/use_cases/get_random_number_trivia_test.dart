import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/usecases/usecases.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/repositories/num_trivia_repo.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  //to run our tests..
  //first instantiate the instances we use..
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  test(
    'should get random number\'s triva from the repository..',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(tNumberTrivia));
      //verify here is a life-saver as themocked repo always will return the sametNumberTrivia
      // so we have to verify the parameters that was passed..
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
