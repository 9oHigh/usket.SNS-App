import 'package:get_it/get_it.dart';
import 'package:sns_app/data/datasources/signin/signin_datasource.dart';
import 'package:sns_app/data/datasources/signup/signup_datasource.dart';
import 'package:sns_app/data/repositories/signin/signin_repository_impl.dart';
import 'package:sns_app/data/repositories/signup/signup_repository_impl.dart';
import 'package:sns_app/domain/repositories/signin/signin_repository.dart';
import 'package:sns_app/domain/repositories/signup/signup_repository.dart';
import 'package:sns_app/domain/usecases/signin/signin_usecase.dart';
import 'package:sns_app/domain/usecases/signup/signup_usecase.dart';

final injector = GetIt.instance;

void provideDataSources() {
  injector.registerFactory<SigninDatasource>(() => SigninDatasource());
  injector.registerFactory<SignupDatasource>(() => SignupDatasource());
}

void provideRepositories() {
  injector.registerFactory<SigninRepository>(
      () => SigninRepositoryImpl(injector.get<SigninDatasource>()));
  injector.registerFactory<SignupRepository>(
      () => SignupRepositoryImpl(injector.get<SignupDatasource>()));
}

void provideUseCases() {
  injector.registerFactory<SigninUsecase>(
      () => SigninUsecase(injector.get<SigninRepository>()));
  injector.registerFactory<SignupUsecase>(
      () => SignupUsecase(injector.get<SignupRepository>()));
}
