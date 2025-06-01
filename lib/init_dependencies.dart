import 'package:expense_tracker_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/core/services/notification_service.dart';
import 'package:expense_tracker_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/get_current_user.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/login_with_email_password.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/sign_up_with_email_password.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/budget/data/data_sources/budget_remote_datasource.dart';
import 'package:expense_tracker_app/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker_app/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/add_new_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/delete_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/edit_budget.dart';
import 'package:expense_tracker_app/features/budget/domain/use_cases/load_budgets.dart';
import 'package:expense_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expense_tracker_app/features/category/data/data_sources/category_remote_datasource.dart';
import 'package:expense_tracker_app/features/category/data/repositories/category_repository_impl.dart';
import 'package:expense_tracker_app/features/category/domain/repositories/category_repository.dart';
import 'package:expense_tracker_app/features/category/domain/use_cases/load_categories.dart';
import 'package:expense_tracker_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker_app/features/setting/data/data_sources/setting_remote_datasource.dart';
import 'package:expense_tracker_app/features/setting/data/repositories/setting_repository_impl.dart';
import 'package:expense_tracker_app/features/setting/domain/repositories/setting_repository.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/load_current_user_settings.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/update_currency.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/update_language.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/data/data_sources/transaction_remote_datasource.dart';
import 'package:expense_tracker_app/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker_app/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/add_new_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/delete_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/edit_transaction.dart';
import 'package:expense_tracker_app/features/transaction/domain/use_cases/load_transactions.dart';
import 'package:expense_tracker_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker_app/features/wallet/data/data_sources/wallet_remote_datasource.dart';
import 'package:expense_tracker_app/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:expense_tracker_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/add_new_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/delete_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/edit_wallet.dart';
import 'package:expense_tracker_app/features/wallet/domain/use_cases/load_wallets.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
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

  serviceLocator.registerLazySingleton(() => NotificationService());

  await serviceLocator<NotificationService>().init();

  _initAuth();
  _initTransaction();
  _initBudget();
  _initWallet();
  _initCategory();
  _initSetting();
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
          settingBloc: serviceLocator()),
    );
}

void _initTransaction() {
  serviceLocator
    //Datasource
    ..registerFactory<TransactionRemoteDatasource>(
      () => TransactionRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<TransactionRepository>(
      () => TransactionRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => LoadTransactions(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddNewTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteTransaction(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => TransactionBloc(
        loadTransactions: serviceLocator(),
        addNewTransaction: serviceLocator(),
        editTransaction: serviceLocator(),
        deleteTransaction: serviceLocator(),
      ),
    );
}

void _initBudget() {
  serviceLocator
    //Datasource
    ..registerFactory<BudgetRemoteDatasource>(
      () => BudgetRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<BudgetRepository>(
      () => BudgetRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => LoadBudgets(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddNewBudget(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditBudget(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteBudget(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BudgetBloc(
        loadBudgets: serviceLocator(),
        addNewBudget: serviceLocator(),
        editBudget: serviceLocator(),
        deleteBudget: serviceLocator(),
      ),
    );
}

void _initWallet() {
  serviceLocator
    //Datasource
    ..registerFactory<WalletRemoteDatasource>(
      () => WalletRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<WalletRepository>(
      () => WalletRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => LoadWallets(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddNewWallet(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditWallet(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteWallet(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => WalletBloc(
        loadWallets: serviceLocator(),
        addNewWallet: serviceLocator(),
        editWallet: serviceLocator(),
        deleteWallet: serviceLocator(),
        // budgetBloc: serviceLocator(),
      ),
    );
}

void _initCategory() {
  serviceLocator
    //Datasource
    ..registerFactory<CategoryRemoteDatasource>(
      () => CategoryRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<CategoryRepository>(
      () => CategoryRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => LoadCategories(
        serviceLocator(),
      ),
    )
    // ..registerFactory(
    //   () => AddNewWallet(
    //     serviceLocator(),
    //   ),
    // )
    // ..registerFactory(
    //   () => GetCurrentUser(
    //     serviceLocator(),
    //   ),
    // )
    //Bloc
    ..registerLazySingleton(
      () => CategoryBloc(
        loadCategories: serviceLocator(),
      ),
    );
}

void _initSetting() {
  serviceLocator
    //Datasource
    ..registerFactory<SettingRemoteDatasource>(
      () => SettingRemoteDatasourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<SettingRepository>(
      () => SettingRepositoryImpl(
        serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => LoadCurrentUserSettings(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateLanguage(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateCurrency(
        serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => SettingBloc(
        loadCurrentUserSettings: serviceLocator(),
        updateLanguage: serviceLocator(),
        updateCurrency: serviceLocator(),
      ),
    );
}
