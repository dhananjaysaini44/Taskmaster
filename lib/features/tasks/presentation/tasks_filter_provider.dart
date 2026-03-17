import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_filter_provider.g.dart';

enum TaskFilter { all, upcoming, completed }

@riverpod
class TasksFilter extends _$TasksFilter {
  @override
  TaskFilter build() => TaskFilter.all;

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}
