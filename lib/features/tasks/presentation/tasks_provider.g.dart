// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksFilterHash() => r'4ef2aa992d1a8d12bed6ef28196d5bd8b221359b';

/// See also [TasksFilter].
@ProviderFor(TasksFilter)
final tasksFilterProvider =
    AutoDisposeNotifierProvider<TasksFilter, TaskFilter>.internal(
  TasksFilter.new,
  name: r'tasksFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TasksFilter = AutoDisposeNotifier<TaskFilter>;
String _$tasksProviderHash() => r'cd2a6c7d7f29e9bc9799b9d3439cd3f566124c58';

/// See also [TasksProvider].
@ProviderFor(TasksProvider)
final tasksProviderProvider =
    AutoDisposeStreamNotifierProvider<TasksProvider, List<TaskModel>>.internal(
  TasksProvider.new,
  name: r'tasksProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TasksProvider = AutoDisposeStreamNotifier<List<TaskModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
