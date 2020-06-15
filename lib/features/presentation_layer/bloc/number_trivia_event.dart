part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

//we will create classes for all the events that need data:
//which in our case are 2 getConcrete.. & getRandom..
class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String stringNumber; //why string not int number..
  //as the textbox outs string 3latool..

  GetConcreteNumberTriviaEvent(this.stringNumber) : super([stringNumber]);
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {}
