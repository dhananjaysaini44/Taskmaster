import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../domain/models/calendar_event_model.dart';
import 'events_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/widgets/color_picker_widget.dart';

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
      backgroundColor: Colors.transparent,
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
          formatButtonVisible: false,
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

class _EventCard extends ConsumerWidget {
  final CalendarEventModel event;
  final AppThemeExtension theme;

  const _EventCard({required this.event, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeFormat = DateFormat('hh:mm a');
    final timeRange = '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: event.isCompleted ? 0.4 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(theme.radiusLG),
          border: Border.all(color: theme.primary.withValues(alpha: 0.1)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(theme.radiusLG),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _AddEventModal(
                initialDate: event.startTime,
                event: event,
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
                            decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeRange,
                          style: theme.labelSmall.copyWith(color: theme.labelSmall.color?.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category, theme).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(event.category),
                      color: _getCategoryColor(event.category, theme),
                      size: 20,
                    ),
                  ),
                ],
              ),
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
        ref.read(eventsProviderProvider.notifier).toggleEventCompletion(event.id);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: event.isCompleted
                ? _getCategoryColor(event.category, theme)
                : theme.textHint.withValues(alpha: 0.5),
            width: 2,
          ),
          color: event.isCompleted ? _getCategoryColor(event.category, theme) : Colors.transparent,
        ),
        child: event.isCompleted
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(eventsProviderProvider.notifier).deleteEvent(event.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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

  Color _getCategoryColor(String category, AppThemeExtension theme) {
    if (event.colorValue != null) {
      return Color(event.colorValue!);
    }
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
  final CalendarEventModel? event;
  const _AddEventModal({required this.initialDate, this.event});

  @override
  ConsumerState<_AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends ConsumerState<_AddEventModal> {
  final _titleController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String _selectedCategory = 'Personal';
  String? _customCategoryName;

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _selectedDate = widget.event!.startTime;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event!.endTime);
      _selectedCategory = widget.event!.category[0].toUpperCase() + widget.event!.category.substring(1);
      // Check if it's a custom category
      final standardCategories = ['Personal', 'Meeting', 'Gym', 'Work'];
      if (!standardCategories.contains(_selectedCategory)) {
        _customCategoryName = _selectedCategory;
        _selectedCategory = 'Custom';
      }
    } else {
      _selectedDate = widget.initialDate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.event?.colorValue != null) {
      _selectedColor = Color(widget.event!.colorValue!);
    } else {
      _selectedColor = Theme.of(context).appTheme.primary;
    }
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
        border: Border.all(
        color: theme.primary.withValues(alpha: 0.1),
        width: 1.5,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.event != null ? 'Edit Event' : 'Add New Event',
                  style: theme.displayLarge.copyWith(fontSize: 28),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: theme.textPrimary),
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
                prefixIcon: Icon(Icons.edit_note_rounded, color: theme.primary),
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
            const SizedBox(height: 24),
            Text(
              'Accent Color',
              style: theme.labelSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ColorPickerWidget(
              presets: const [
                Color(0xFF42A5F5),
                Color(0xFF66BB6A),
                Color(0xFFFFA726),
                Color(0xFFEF5350),
                Color(0xFFAB47BC),
              ],
              selected: _selectedColor,
              onChanged: (color) => setState(() => _selectedColor = color),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: theme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: theme.primary.withValues(alpha: 0.4),
                ),
                child: Text(
                  widget.event != null ? 'Update Event' : 'Save Event',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(theme.radiusMD),
              border: Border.all(color: theme.borderSecondary),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 18, color: theme.primary),
                const SizedBox(width: 12),
                Text(
                  DateFormat('EEEE, MMM dd').format(_selectedDate),
                  style: theme.bodyMedium,
                ),
                const Spacer(),
                Icon(Icons.edit, size: 16, color: theme.textHint),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _startTime);
                  if (picked != null) setState(() => _startTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                    border: Border.all(color: theme.borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18, color: theme.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Start: ${_startTime.format(context)}',
                        style: theme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _endTime);
                  if (picked != null) setState(() => _endTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                    border: Border.all(color: theme.borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18, color: theme.primary),
                      const SizedBox(width: 12),
                      Text(
                        'End: ${_endTime.format(context)}',
                        style: theme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AppThemeExtension theme) {
    final categories = ['Personal', 'Meeting', 'Gym', 'Work', 'Custom'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: theme.labelSmall.copyWith(color: theme.textSecondary.withValues(alpha: 0.7))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            final label = (cat == 'Custom' && _customCategoryName != null) ? _customCategoryName! : cat;
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) async {
                if (selected) {
                  if (cat == 'Custom') {
                    final name = await _showCustomCategoryDialog(context);
                    if (name != null && name.isNotEmpty) {
                      setState(() {
                        _selectedCategory = cat;
                        _customCategoryName = name;
                      });
                    }
                  } else {
                    setState(() {
                      _selectedCategory = cat;
                      _customCategoryName = null;
                    });
                  }
                }
              },
              backgroundColor: theme.background,
              selectedColor: theme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : theme.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? theme.primary : theme.primary.withValues(alpha: 0.1)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<String?> _showCustomCategoryDialog(BuildContext context) async {
    final theme = Theme.of(context).appTheme;
    String customName = _customCategoryName ?? '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        title: Text('Custom Category', style: theme.titleMedium),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            hintStyle: TextStyle(color: theme.textHint),
          ),
          style: TextStyle(color: theme.textPrimary),
          onChanged: (value) => customName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: theme.textHint)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, customName),
            child: Text('OK', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
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

    final category = (_selectedCategory == 'Custom' && _customCategoryName != null) 
        ? _customCategoryName!.toLowerCase() 
        : _selectedCategory.toLowerCase();

    if (widget.event != null) {
      final updatedEvent = widget.event!.copyWith(
        title: _titleController.text,
        startTime: start,
        endTime: end,
        category: category,
        colorValue: _selectedColor.toARGB32(),
      );
      ref.read(eventsProviderProvider.notifier).updateEvent(updatedEvent);
    } else {
      final event = CalendarEventModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        startTime: start,
        endTime: end,
        category: category,
        colorValue: _selectedColor.toARGB32(),
      );
      ref.read(eventsProviderProvider.notifier).addEvent(event);
    }
    Navigator.pop(context);
  }
}
