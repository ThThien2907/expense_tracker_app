part of 'setting_bloc.dart';

enum SettingStatus { initial, loading, success, failure }

final class SettingState extends Equatable {
  final SettingStatus status;
  final SettingEntity setting;
  final String errorMessage;

  const SettingState({
    this.status = SettingStatus.initial,
    this.setting = const SettingEntity(
      settingId: '',
      userId: '',
      currency: 'VND',
      language: 'vi',
    ),
    this.errorMessage = '',
  });

  SettingState copyWith({
    SettingStatus? status,
    SettingEntity? setting,
    String? errorMessage,
    String? settingId,
    String? userId,
    String? currency,
    String? language,
  }) {
    return SettingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      setting: setting ??
          this.setting.copyWith(
                settingId: settingId ?? this.setting.settingId,
                userId: userId ?? this.setting.userId,
                currency: currency ?? this.setting.currency,
                language: language ?? this.setting.language,
              ),
    );
  }

  @override
  List<Object?> get props => [status, setting, errorMessage];
}
