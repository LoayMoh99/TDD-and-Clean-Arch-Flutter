part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia}) : super([trivia]);
}

class Error extends NumberTriviaState {
  final String errorMsg;

  Error({@required this.errorMsg}) : super([errorMsg]);
}
