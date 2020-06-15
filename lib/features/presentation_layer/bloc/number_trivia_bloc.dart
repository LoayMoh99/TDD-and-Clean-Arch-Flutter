import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_app/core/errors/failure.dart';
import 'package:number_trivia_app/core/usecases/usecases.dart';
import 'package:number_trivia_app/core/utilities/input_converter.dart';
import 'package:number_trivia_app/features/domain_layer/entities/number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/domain_layer/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    // Changed the name of the constructor parameter (cannot use 'this.')
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
    // Asserts are how you can make sure that a passed in argument is not null.
    // We omit this elsewhere for the sake of brevity.
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;
/////////////////////////////////////////////////////////////////////////////
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetConcreteNumberTriviaEvent) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.stringNumber);

      yield* inputEither.fold((failure) async* {
        yield Error(errorMsg: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        yield failureOrTrivia.fold(
          (failure) => Error(
            errorMsg: _mapFailureMessage(failure),
          ),
          (trivia) => Loaded(trivia: trivia),
        );
      });
    } else if (event is GetRandomNumberTriviaEvent) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield failureOrTrivia.fold(
        (failure) => Error(
          errorMsg: _mapFailureMessage(failure),
        ),
        (trivia) => Loaded(trivia: trivia),
      );
    }
  }

  String _mapFailureMessage(Failure failure) {
    if (failure is ServerFailure)
      return SERVER_FAILURE_MESSAGE;
    else if (failure is CacheFailure)
      return CACHE_FAILURE_MESSAGE;
    else
      return 'Unexpected Error!!';
  }
}
