class SettingEntity {
  final String settingId;
  final String userId;
  final String currency;
  final String language;

  const SettingEntity({
    required this.settingId,
    required this.userId,
    required this.currency,
    required this.language,
  });

  SettingEntity copyWith({
    String? settingId,
    String? userId,
    String? currency,
    String? language,
  }) {
    return SettingEntity(
      settingId: settingId ?? this.settingId,
      userId: userId ?? this.userId,
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }
}
