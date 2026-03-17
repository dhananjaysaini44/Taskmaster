// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      themeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      defaultAccentColorValue:
          (json['defaultAccentColorValue'] as num?)?.toInt() ?? 0xFF3B82F6,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'defaultAccentColorValue': instance.defaultAccentColorValue,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
