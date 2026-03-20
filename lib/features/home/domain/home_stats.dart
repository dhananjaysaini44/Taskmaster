import '../../tasks/domain/task_model.dart';

class HomeStats {
  final int totalTasks;
  final int completedTasks;
  final int efficiency;
  final int highPriority;
  final int mediumPriority;
  final int lowPriority;

  const HomeStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.efficiency,
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
  });

  factory HomeStats.fromTasks(List<TaskModel> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final efficiency = total > 0 ? (completed / total * 100).toInt() : 0;

    final high = tasks.where((t) => t.priority == TaskPriority.high).length;
    final medium = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final low = tasks.where((t) => t.priority == TaskPriority.low).length;

    return HomeStats(
      totalTasks: total,
      completedTasks: completed,
      efficiency: efficiency,
      highPriority: high,
      mediumPriority: medium,
      lowPriority: low,
    );
  }
}
