// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsProviderHash() => r'62792cc2aa3f874a2a3ab1e8a821993ee759f8c3';

/// See also [EventsProvider].
@ProviderFor(EventsProvider)
final eventsProviderProvider =
    AutoDisposeNotifierProvider<
      EventsProvider,
      AsyncValue<List<CalendarEventModel>>
    >.internal(
      EventsProvider.new,
      name: r'eventsProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$eventsProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EventsProvider =
    AutoDisposeNotifier<AsyncValue<List<CalendarEventModel>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
