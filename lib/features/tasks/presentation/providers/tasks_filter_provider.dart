import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/task_filter.dart';

part 'tasks_filter_provider.g.dart';

@riverpod
class TasksFilter extends _$TasksFilter {
  @override
  TaskFilter build() => TaskFilter.all;

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}
