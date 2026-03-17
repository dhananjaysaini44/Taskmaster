import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../domain/models/calendar_event_model.dart';
import 'events_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<CalendarEventModel> _getEventsForDay(DateTime day, List<CalendarEventModel> allEvents) {
    return allEvents.where((event) => isSameDay(event.startTime, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final eventsAsync = ref.watch(eventsProviderProvider);

    return Scaffold(
      backgroundColor: theme.background,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: Text('Calendar'),
      ),
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

  Widget _buildBody(BuildContext context, AppThemeExtension theme, List<CalendarEventModel> events) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + theme.spacingMD),
        _buildCalendar(theme, events),
        const SizedBox(height: 16),
        _buildEventsHeader(theme),
        Expanded(
          child: _buildEventsList(theme, events),
        ),
      ],
    );
  }

  Widget _buildCalendar(AppThemeExtension theme, List<CalendarEventModel> events) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
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
            color: theme.primary.withValues(alpha: 0.3),
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
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonTextStyle: TextStyle(color: theme.textSecondary),
          formatButtonDecoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: theme.textSecondary),
          rightChevronIcon: Icon(Icons.chevron_right, color: theme.textSecondary),
          titleTextStyle: theme.titleMedium.copyWith(fontWeight: FontWeight.bold),
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
            style: theme.labelSmall.copyWith(color: theme.labelSmall.color?.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(AppThemeExtension theme, List<CalendarEventModel> events) {
    final dayEvents = _getEventsForDay(_selectedDay ?? DateTime.now(), events);

    if (dayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available_outlined, size: 64, color: theme.labelSmall.color?.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'No events for this day',
              style: theme.bodyMedium.copyWith(color: theme.labelSmall.color?.withValues(alpha: 0.4)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG, vertical: 8),
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return _EventCard(event: event, theme: theme);
      },
    );
  }

  void _showAddEventModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddEventModal(initialDate: _selectedDay ?? DateTime.now()),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CalendarEventModel event;
  final AppThemeExtension theme;

  const _EventCard({required this.event, required this.theme});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    final timeRange = '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getCategoryColor(event.category, theme).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(event.category),
              color: _getCategoryColor(event.category, theme),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.titleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  timeRange,
                  style: theme.labelSmall.copyWith(color: theme.labelSmall.color?.withValues(alpha: 0.6)),
                ),
              ],
            ),
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

  Color _getCategoryColor(String category, AppThemeExtension theme) {
    switch (category.toLowerCase()) {
      case 'meeting':
        return theme.primary;
      case 'gym':
        return theme.accent;
      case 'work':
        return Colors.orangeAccent;
      case 'personal':
        return Colors.purpleAccent;
      default:
        return theme.primary;
    }
  }
}

class _AddEventModal extends ConsumerStatefulWidget {
  final DateTime initialDate;
  const _AddEventModal({required this.initialDate});

  @override
  ConsumerState<_AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends ConsumerState<_AddEventModal> {
  final _titleController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String _selectedCategory = 'Personal';

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add New Event', style: theme.titleLarge),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              autofocus: true,
              style: TextStyle(color: theme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Event Title',
                hintStyle: TextStyle(color: theme.textHint),
                filled: true,
                fillColor: theme.background.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDateTimePicker(theme),
            const SizedBox(height: 24),
            _buildCategorySelector(theme),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(AppThemeExtension theme) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.calendar_today, color: theme.primary),
          title: Text(DateFormat('EEEE, MMM dd').format(_selectedDate), style: TextStyle(color: theme.textPrimary)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
        ),
        const Divider(color: Colors.white10),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.access_time, color: theme.primary),
                title: Text('Start: ${_startTime.format(context)}', style: TextStyle(color: theme.textPrimary)),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _startTime);
                  if (picked != null) setState(() => _startTime = picked);
                },
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.access_time, color: theme.primary),
                title: Text('End: ${_endTime.format(context)}', style: TextStyle(color: theme.textPrimary)),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _endTime);
                  if (picked != null) setState(() => _endTime = picked);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AppThemeExtension theme) {
    final categories = ['Personal', 'Meeting', 'Gym', 'Work'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCategory = cat);
              },
              backgroundColor: theme.background,
              selectedColor: theme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : Colors.white70,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? theme.primary : Colors.white10),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty) return;

    final start = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final end = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    final event = CalendarEventModel(
      id: const Uuid().v4(),
      title: _titleController.text,
      startTime: start,
      endTime: end,
      category: _selectedCategory.toLowerCase(),
    );

    ref.read(eventsProviderProvider.notifier).addEvent(event);
    Navigator.pop(context);
  }
}
