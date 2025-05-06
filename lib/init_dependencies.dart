import 'package:expense_tracker_app/core/common/cubits/app_user_cubit.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/get_current_user.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/login_with_email_password.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/sign_up_with_email_password.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: 'https://harzbvmqcfbokibcctss.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhhcnpidm1xY2Zib2tpYmNjdHNzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMyMzE4NzgsImV4cCI6MjA1ODgwNzg3OH0.jWCQ4bkXP8y2z5DccSG3gXg0gFtZjlieRzlqcUyy6kY',
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(() => ConnectionChecker());

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  _initAuth();
}

void _initAuth() {
  serviceLocator
    //Datasource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => SignUpWithEmailPassword(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => LoginWithEmailPassword(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetCurrentUser(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        signUpWithEmailPassword: serviceLocator(),
        loginWithEmailPassword: serviceLocator(),
        getCurrentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
