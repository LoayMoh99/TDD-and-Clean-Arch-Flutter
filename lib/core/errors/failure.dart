import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  //this class help if there is any failure occured in the repository..
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

//usually failiures is 1:1 to exceptions
//general failures:
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
