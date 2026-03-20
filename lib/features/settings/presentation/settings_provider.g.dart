// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsRepositoryHash() =>
    r'c5a39438caec85b55a650dcd24bd66b30ea47e8f';

/// See also [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
  settingsRepository,
  name: r'settingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
String _$settingsProviderHash() => r'3da7054d634812eb43a4057fab3a76f945abadc9';

/// See also [SettingsProvider].
@ProviderFor(SettingsProvider)
final settingsProviderProvider =
    AutoDisposeNotifierProvider<SettingsProvider, SettingsState>.internal(
  SettingsProvider.new,
  name: r'settingsProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsProvider = AutoDisposeNotifier<SettingsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
