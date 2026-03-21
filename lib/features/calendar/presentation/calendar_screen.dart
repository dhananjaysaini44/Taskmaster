import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../domain/models/calendar_event_model.dart';
import 'events_provider.dart';
import 'package:intl/intl.dart';
import 'widgets/add_event_modal.dart';
import 'event_detail_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showCompletedEvents = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<CalendarEventModel> _getEventsForDay(
    DateTime day,
    List<CalendarEventModel> allEvents,
  ) {
    return allEvents.where((event) => isSameDay(event.startTime, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final eventsAsync = ref.watch(eventsProviderProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: eventsAsync.when(
        data: (events) => _buildBody(context, theme, events),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventModal(context),
        backgroundColor: theme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppThemeExtension theme,
    List<CalendarEventModel> events,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + theme.spacingLG * 0.73,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFocusFlowHeader(theme, events),
          SizedBox(height: theme.spacingLG),
          _buildCalendar(theme, events),
          SizedBox(height: theme.spacingLG),
          _buildEventsHeader(theme),
          _buildEventsList(theme, events),
          SizedBox(height: theme.spacingLG),
          _buildStreakContainer(theme, events),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFocusFlowHeader(AppThemeExtension theme, List<CalendarEventModel> events) {
    final dayEvents = _getEventsForDay(_selectedDay ?? DateTime.now(), events);
    final pendingCount = dayEvents.where((e) => !e.isCompleted).length;
    final dateStr = _getOrdinalDate(_selectedDay ?? DateTime.now());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: theme.labelSmall.copyWith(
              color: theme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Focus Flow',
            style: theme.displayLarge.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: theme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              style: theme.bodySmall.copyWith(
                fontSize: 15,
                color: theme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(text: "You have "),
                TextSpan(
                  text: "$pendingCount ${pendingCount == 1 ? 'event' : 'events'}",
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: " remaining for the day"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getOrdinalDate(DateTime date) {
    final day = date.day;
    String suffix = 'th';
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return "${DateFormat('MMMM d').format(date)}$suffix, ${DateFormat('yyyy').format(date)}";
  }

  Widget _buildCalendar(
    AppThemeExtension theme,
    List<CalendarEventModel> events,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSecondary),
      ),
      child: TableCalendar<CalendarEventModel>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        eventLoader: (day) => _getEventsForDay(day, events),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: theme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: theme.accent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(color: theme.textSecondary),
          weekendTextStyle: TextStyle(color: theme.textHint),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(Icons.chevron_left, color: theme.textSecondary),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: theme.textSecondary,
          ),
          titleTextStyle: theme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsHeader(AppThemeExtension theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Row(
        children: [
          Text(
            'Schedule',
            style: theme.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            DateFormat('MMMM dd, yyyy').format(_selectedDay ?? DateTime.now()),
            style: theme.labelSmall.copyWith(
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(
    AppThemeExtension theme,
    List<CalendarEventModel> events,
  ) {
    final dayEvents = _getEventsForDay(_selectedDay ?? DateTime.now(), events);
    final pendingEvents = dayEvents.where((e) => !e.isCompleted).toList();
    final completedEvents = dayEvents.where((e) => e.isCompleted).toList();

    if (dayEvents.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacingXL),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_available_outlined,
                size: 48,
                color: theme.textHint.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 12),
              Text(
                'No events for this day',
                style: theme.bodyMedium.copyWith(
                  color: theme.textHint,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (pendingEvents.isNotEmpty)
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: theme.spacingLG, vertical: 8),
            itemCount: pendingEvents.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final event = pendingEvents[index];
              return _EventCard(event: event, theme: theme);
            },
          ),
        if (completedEvents.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
            child: TextButton.icon(
              onPressed: () => setState(() => _showCompletedEvents = !_showCompletedEvents),
              icon: Icon(
                _showCompletedEvents ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
                color: theme.textSecondary,
              ),
              label: Text(
                '${_showCompletedEvents ? 'Hide' : 'Show'} Completed (${completedEvents.length})',
                style: theme.labelSmall.copyWith(
                  color: theme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_showCompletedEvents)
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: theme.spacingLG, vertical: 8),
              itemCount: completedEvents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final event = completedEvents[index];
                return _EventCard(event: event, theme: theme);
              },
            ),
        ],
      ],
    );
  }

  Widget _buildStreakContainer(
    AppThemeExtension theme,
    List<CalendarEventModel> events,
  ) {
    final streak = _calculateStreak(events);
    final totalCompleted = events.where((e) => e.isCompleted).length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      padding: EdgeInsets.all(theme.spacingLG),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(theme.radiusXL),
        boxShadow: [
          BoxShadow(
            color: theme.secondary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 32,
              ),
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$streak Day Streak',
                    style: theme.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$totalCompleted',
            style: theme.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'TOTAL COMPLETED',
            style: theme.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStreak(List<CalendarEventModel> events) {
    final now = DateTime.now();
    // Filter events that have finished and are not all-day (or handle all-day similarly)
    final pastEvents = events.where((e) => e.endTime.isBefore(now)).toList()
      ..sort((a, b) => b.endTime.compareTo(a.endTime));

    int streak = 0;
    for (final event in pastEvents) {
      if (event.isCompleted) {
        streak++;
      } else {
        // Streak breaks at the first missed event (ended but not completed)
        break;
      }
    }
    return streak;
  }

  void _showAddEventModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddEventModal(initialDate: _selectedDay ?? DateTime.now()),
    );
  }
}

class _EventCard extends ConsumerWidget {
  final CalendarEventModel event;
  final AppThemeExtension theme;

  const _EventCard({required this.event, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('hh:mm a');
    final timeRange =
        '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSecondary),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          ),
          onLongPress: () => _showDeleteDialog(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCheckmark(context, ref),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: theme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: event.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: event.isCompleted ? theme.textHint : theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeRange,
                        style: theme.labelSmall.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                      if (event.notes != null && event.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodySmall.copyWith(
                            color: theme.textHint,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      theme,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(event.category),
                    color: _getCategoryColor(theme),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckmark(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Toggle completion
        ref
            .read(eventsProviderProvider.notifier)
            .toggleEventCompletion(event.id);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: event.isCompleted
                ? _getCategoryColor(theme)
                : theme.textHint.withValues(alpha: 0.5),
            width: 2,
          ),
          color: event.isCompleted
              ? _getCategoryColor(theme)
              : Colors.transparent,
        ),
        child: event.isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Event', style: theme.titleMedium),
        content: Text('Are you sure you want to delete this event?', style: theme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: theme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(eventsProviderProvider.notifier).deleteEvent(event.id);
            },
            style: TextButton.styleFrom(foregroundColor: theme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'meeting':
        return Icons.video_camera_front_outlined;
      case 'gym':
        return Icons.fitness_center_outlined;
      case 'work':
        return Icons.work_outline;
      case 'personal':
        return Icons.person_outline;
      default:
        return Icons.event_outlined;
    }
  }

  Color _getCategoryColor(AppThemeExtension theme) {
    return event.isCompleted ? Colors.blue : Colors.red;
  }
}

