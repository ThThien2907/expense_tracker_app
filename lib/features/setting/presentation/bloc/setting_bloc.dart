import 'package:equatable/equatable.dart';
import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/load_current_user_settings.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/update_currency.dart';
import 'package:expense_tracker_app/features/setting/domain/use_cases/update_language.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';

part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final LoadCurrentUserSettings _loadCurrentUserSettings;
  final UpdateLanguage _updateLanguage;
  final UpdateCurrency _updateCurrency;

  SettingBloc({
    required LoadCurrentUserSettings loadCurrentUserSettings,
    required UpdateLanguage updateLanguage,
    required UpdateCurrency updateCurrency,
  })  : _loadCurrentUserSettings = loadCurrentUserSettings,
        _updateLanguage = updateLanguage,
        _updateCurrency = updateCurrency,
        super(const SettingState())
  {
    on<SettingStarted>(_onSettingStarted);
    on<ClearSettings>(_onClearSettings);
    on<SettingLanguageChanged>(_onSettingLanguageChanged);
    on<SettingCurrencyChanged>(_onSettingCurrencyChanged);
  }

  _onSettingStarted(
    SettingStarted event,
    Emitter emit,
  ) async {
    if (event.settingEntity != null){
      emit(state.copyWith(
        status: SettingStatus.success,
        setting: event.settingEntity,
      ));
    }
    else {
      final response = await _loadCurrentUserSettings.call();

      response.fold(
            (ifLeft) {
          emit(state.copyWith(
            status: SettingStatus.failure,
            errorMessage: ifLeft,
          ));
        },
            (ifRight) {
          emit(state.copyWith(
            status: SettingStatus.success,
            setting: ifRight,
          ));
        },
      );
    }
  }

  _onClearSettings(
    ClearSettings event,
    Emitter emit,
  ) {
    emit(state.copyWith(
      status: SettingStatus.initial,
      settingId: '',
      userId: '',
      currency: 'VND',
      errorMessage: '',
    ));
  }

  _onSettingLanguageChanged(
    SettingLanguageChanged event,
    Emitter emit,
  ) async {
    if (state.setting.userId.isEmpty) {
      emit(state.copyWith(language: event.language));
    } else {
      emit(state.copyWith(status: SettingStatus.loading));

      var response = await _updateLanguage.call(
        params: UpdateLanguageParams(
          language: event.language,
          userId: state.setting.userId,
        ),
      );

      response.fold(
        (ifLeft) {
          emit(state.copyWith(
            status: SettingStatus.failure,
            errorMessage: ifLeft,
          ));
        },
        (ifRight) {
          emit(state.copyWith(
            status: SettingStatus.success,
            setting: ifRight,
          ));
        },
      );
    }
  }

  _onSettingCurrencyChanged(
    SettingCurrencyChanged event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: SettingStatus.loading));

    var response = await _updateCurrency.call(
      params: UpdateCurrencyParams(
        currency: event.currency,
        userId: state.setting.userId,
      ),
    );

    response.fold(
          (ifLeft) {
        emit(state.copyWith(
          status: SettingStatus.failure,
          errorMessage: ifLeft,
        ));
      },
          (ifRight) {
        emit(state.copyWith(
          status: SettingStatus.success,
          setting: ifRight,
        ));
      },
    );
  }
}
