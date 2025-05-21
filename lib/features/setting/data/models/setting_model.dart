import 'package:expense_tracker_app/features/setting/domain/entities/setting_entity.dart';

class SettingModel extends SettingEntity {
  SettingModel({
    required super.settingId,
    required super.userId,
    required super.currency,
    required super.language,
  });

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      settingId: map['setting_id'],
      userId: map['user_id'],
      currency: map['currency'] ?? '',
      language: map['language'] ?? '',
    );
  }
}
