import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utilities/input_converter.dart';
import 'features/data_layer/data_sources/number_trivia_local_datasource.dart';
import 'features/data_layer/data_sources/number_trivia_remote_datasource.dart';
import 'features/data_layer/repositories/number_trivia_repository_impl.dart';
import 'features/domain_layer/repositories/num_trivia_repo.dart';
import 'features/domain_layer/use_cases/get_concrete_number_trivia.dart';
import 'features/domain_layer/use_cases/get_random_number_trivia.dart';
import 'features/presentation_layer/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance; //sl =>service locator

//!we have to init the dependencies from up to down with respect to "Call Flow":
/*Notes:(Factory Vs Singleton)
=>Factories: when registering a factory we instantiate a new instance of the class we calling..
  classes which req cleanup as Bloc can't be singleton ->factory
=>Singleton:when registerring it after creating it in the first time->it will call the same instance again,
  Now diff between non-lazy and lazy singleton is nonlazy registered directly 
  when app is open while lazy is registered when it is called..
*/
Future<void> init() async {
  //! Features:(Number Trivia)
  //bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );
  //use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  //repository:
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      //we called impl as NumTriRepo is abstract class
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  //data sources:
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDatasourceImpl(sharedPreferences: sl()));

  //! Core:
  //input converter:
  sl.registerLazySingleton(() => InputConverter());
  //network info:
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Externals:
  //http.client:
  sl.registerLazySingleton(() => http.Client());
  //shared prefrences:
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  //data connection checker
  sl.registerLazySingleton(() => DataConnectionChecker());
}
