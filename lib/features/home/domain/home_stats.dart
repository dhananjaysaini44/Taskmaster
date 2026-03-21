import '../../tasks/domain/task_model.dart';
import '../../calendar/domain/models/calendar_event_model.dart';

class HomeStats {
  final int totalTasks;
  final int completedTasks;
  final int efficiency;
  final int highPriority;
  final int mediumPriority;
  final int lowPriority;
  final Map<DateTime, int> dailyCompletions;
  final List<int> dailyProductivity; // Last 7 days combined counts (tasks + events)

  const HomeStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.efficiency,
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
    required this.dailyCompletions,
    required this.dailyProductivity,
  });

  factory HomeStats.calculate({
    required List<TaskModel> tasks,
    required List<CalendarEventModel> events,
  }) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final efficiency = total > 0 ? (completed / total * 100).toInt() : 0;

    final high = tasks.where((t) => t.priority == TaskPriority.high).length;
    final medium = tasks.where((t) => t.priority == TaskPriority.medium).length;
    final low = tasks.where((t) => t.priority == TaskPriority.low).length;

    // Calculate daily completions for the last 7 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    final dailyCompletionsMap = {
      for (var day in last7Days)
        day: tasks.where((t) {
          final localCompletedAt = t.completedAt?.toLocal();
          final localDueDate = t.dueDate.toLocal();
          
          final date = localCompletedAt ?? 
                      (t.status == TaskStatus.completed ? localDueDate : null);
          
          if (date == null) return false;
          
          return date.year == day.year && 
                 date.month == day.month && 
                 date.day == day.day;
        }).length
    };

    final dailyProductivityList = last7Days.map((day) {
      return tasks.where((t) {
        final localCompletedAt = t.completedAt?.toLocal();
        final localDueDate = t.dueDate.toLocal();
        
        final date = localCompletedAt ?? 
                    (t.status == TaskStatus.completed ? localDueDate : null);
        
        if (date == null) return false;
        
        return date.year == day.year && 
               date.month == day.month && 
               date.day == day.day;
      }).length;
    }).toList();

    return HomeStats(
      totalTasks: total,
      completedTasks: completed,
      efficiency: efficiency,
      highPriority: high,
      mediumPriority: medium,
      lowPriority: low,
      dailyCompletions: dailyCompletionsMap,
      dailyProductivity: dailyProductivityList,
    );
  }
}
