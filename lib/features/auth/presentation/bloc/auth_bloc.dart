import 'package:expense_tracker_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:expense_tracker_app/features/auth/data/models/user_model.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/get_current_user.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/login_with_email_password.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/login_with_google.dart';
import 'package:expense_tracker_app/features/auth/domain/use_cases/sign_up_with_email_password.dart';
import 'package:expense_tracker_app/features/setting/data/models/setting_model.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpWithEmailPassword _signUpWithEmailPassword;
  final LoginWithEmailPassword _loginWithEmailPassword;
  final GetCurrentUser _getCurrentUser;
  final LoginWithGoogle _loginWithGoogle;
  final AppUserCubit _appUserCubit;
  final SettingBloc _settingBloc;

  AuthBloc({
    required SignUpWithEmailPassword signUpWithEmailPassword,
    required LoginWithEmailPassword loginWithEmailPassword,
    required GetCurrentUser getCurrentUser,
    required LoginWithGoogle loginWithGoogle,
    required AppUserCubit appUserCubit,
    required SettingBloc settingBloc,
  })  : _signUpWithEmailPassword = signUpWithEmailPassword,
        _loginWithEmailPassword = loginWithEmailPassword,
        _getCurrentUser = getCurrentUser,
        _loginWithGoogle = loginWithGoogle,
        _appUserCubit = appUserCubit,
        _settingBloc = settingBloc,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    on<AuthSignUp>(_onAuthSignUp);

    on<AuthLogin>(_onAuthLogin);

    on<AuthLoggedIn>(_onAuthLoggedIn);

    on<AuthLoginWithGoogle>(_onAuthLoginWithGoogle);
  }

  _onAuthSignUp(AuthSignUp event, Emitter emit) async {
    final response = await _signUpWithEmailPassword.call(
      params: SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        language: event.language,
      ),
    );

    response.fold(
      (ifLeft) => emit(AuthFailure(errorMessage: ifLeft)),
      (ifRight) => emit(const AuthSuccess()),
    );
  }

  _onAuthLogin(AuthLogin event, Emitter emit) async {
    final response = await _loginWithEmailPassword.call(
      params: LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (ifLeft) => emit(AuthFailure(errorMessage: ifLeft)),
      (ifRight) {
        Map<String, dynamic> data = ifRight.first;
        UserModel user = UserModel.fromMap(data);
        _appUserCubit.setUser(user);
        SettingModel setting = SettingModel.fromMap(data['settings'].first);
        _settingBloc.add(SettingStarted(
          settingEntity: setting,
        ));
        emit(const AuthSuccess());
      },
    );
  }

  _onAuthLoggedIn(AuthLoggedIn event, Emitter emit) async {
    final response = await _getCurrentUser.call();

    response.fold(
      (ifLeft) {
        emit(AuthFailure(errorMessage: ifLeft));
      },
      (ifRight) {
        if (ifRight == null) {
          emit(AuthInitial());
        } else {
          Map<String, dynamic> data = ifRight.first;
          UserModel user = UserModel.fromMap(data);
          _appUserCubit.setUser(user);
          SettingModel setting = SettingModel.fromMap(data['settings'].first);
          _settingBloc.add(SettingStarted(
            settingEntity: setting,
          ));
          emit(const AuthSuccess());
        }
      },
    );
  }

  _onAuthLoginWithGoogle(
    AuthLoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _loginWithGoogle.call(
      params: LoginWithGoogleParams(language: event.language),
    );
    response.fold(
      (ifLeft) => emit(AuthFailure(errorMessage: ifLeft)),
      (ifRight) {
        Map<String, dynamic> data = ifRight.first;
        UserModel user = UserModel.fromMap(data);
        _appUserCubit.setUser(user);
        SettingModel setting = SettingModel.fromMap(data['settings'].first);
        _settingBloc.add(SettingStarted(
          settingEntity: setting,
        ));
        emit(const AuthSuccess(provider: 'google'));
      },
    );
  }
}
