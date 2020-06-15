import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/usecases/usecases.dart';
import 'package:number_trivia_app/core/utilities/input_converter.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/presentation_layer/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  //first test is initialState:
  test('should return Empty in initialState of bloc..', () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });
  //secondly we will test the GetConcreteNumberTriviaEvent:
  group('GetConcreteNumberTriviaEvent', () {
    final tNumberString = '1';
    final tNumberParse = 1;
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParse));
    }

    test(
      'should call the InputConverter to validate and convert the string to unsigned int..',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
        //but as stringToUnsignedInteger is async so the test fails so to pass it:
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InputConvertionFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          Empty(),
          Error(errorMsg: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should get data from the concrete usecase',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
        //but as stringToUnsignedInteger is async so the test fails so to pass it:
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParse)));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data fails to be gotten',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with proper error message;this time is CacheFailure',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });
///////////////Random////////////////////
  group('GetRandomNumberTriviaEvent', () {
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    test(
      'should get data from the random usecase',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetRandomNumberTriviaEvent());
        await untilCalled(mockGetRandomNumberTrivia(NoParams()));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetRandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [Loading, Error] when data fails to be gotten',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetRandomNumberTriviaEvent());
      },
    );

    test(
      'should emit [Loading, Error] with proper error message',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMsg: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetRandomNumberTriviaEvent());
      },
    );
  });
}
