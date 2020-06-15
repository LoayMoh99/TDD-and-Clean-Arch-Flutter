import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/repositories/num_trivia_repo.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  //to run our tests..
  //first instantiate the instances we use..
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);
  test(
    'should get the number\'s triva from the repository..',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      final result = await useCase(Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      //verify here is a life-saver as themocked repo always will return the sametNumberTrivia
      // so we have to verify the parameters that was passed..
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
