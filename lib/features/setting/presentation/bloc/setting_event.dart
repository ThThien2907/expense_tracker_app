part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();
}

final class SettingStarted extends SettingEvent{
  final SettingEntity? settingEntity;

  const SettingStarted({this.settingEntity});

  @override
  List<Object?> get props => [settingEntity];
}

final class ClearSettings extends SettingEvent{
  @override
  List<Object?> get props => [];
}

final class SettingLanguageChanged extends SettingEvent{
  final String language;

  const SettingLanguageChanged({required this.language});

  @override
  List<Object?> get props => [language];
}

final class SettingCurrencyChanged extends SettingEvent{
  final String currency;

  const SettingCurrencyChanged({required this.currency});

  @override
  List<Object?> get props => [currency];
}
