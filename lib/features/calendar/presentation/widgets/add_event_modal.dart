import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../shared/widgets/color_picker_widget.dart';
import '../../domain/models/calendar_event_model.dart';
import '../providers/events_provider.dart';

class AddEventModal extends ConsumerStatefulWidget {
  final CalendarEventModel? event;
  final DateTime initialDate;

  const AddEventModal({
    super.key,
    this.event,
    required this.initialDate,
  });

  @override
  ConsumerState<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends ConsumerState<AddEventModal> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String _selectedCategory = 'Personal';
  String? _customCategoryName;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _notesController.text = widget.event!.notes ?? '';
      _selectedDate = widget.event!.startTime;
      _startTime = TimeOfDay.fromDateTime(widget.event!.startTime);
      _endTime = TimeOfDay.fromDateTime(widget.event!.endTime);
      
      final rawCat = widget.event!.category;
      if (rawCat.isNotEmpty) {
        final formattedCat = rawCat[0].toUpperCase() + rawCat.substring(1);
        final standardCategories = ['Personal', 'Meeting', 'Gym', 'Work'];
        if (standardCategories.contains(formattedCat)) {
          _selectedCategory = formattedCat;
        } else {
          _selectedCategory = 'Custom';
          _customCategoryName = formattedCat;
        }
      }
    } else {
      _selectedDate = widget.initialDate;
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
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
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
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
          color: theme.borderSecondary,
          width: 1,
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
                fillColor: theme.background,
                prefixIcon: Icon(Icons.edit_note_rounded, color: theme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.borderSecondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.borderSecondary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              style: TextStyle(color: theme.textPrimary),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description / Notes',
                hintStyle: TextStyle(color: theme.textHint),
                filled: true,
                fillColor: theme.background,
                prefixIcon: Icon(Icons.description_rounded, color: theme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.borderSecondary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.borderSecondary),
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
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.event != null ? 'Update Event' : 'Save Event',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
              color: theme.background,
              borderRadius: BorderRadius.circular(theme.radiusMD),
              border: Border.all(color: theme.borderSecondary),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: theme.primary,
                ),
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
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _startTime,
                  );
                  if (picked != null) setState(() => _startTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                    border: Border.all(color: theme.borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: theme.primary,
                      ),
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
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _endTime,
                  );
                  if (picked != null) setState(() => _endTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                    border: Border.all(color: theme.borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: theme.primary,
                      ),
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
        Text(
          'Category',
          style: theme.labelSmall.copyWith(
            color: theme.textSecondary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            final label = (cat == 'Custom' && _customCategoryName != null)
                ? _customCategoryName!
                : cat;
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
              selectedColor: theme.primary.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : theme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? theme.primary
                      : theme.borderSecondary,
                ),
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

    final category =
        (_selectedCategory == 'Custom' && _customCategoryName != null)
        ? _customCategoryName!.toLowerCase()
        : _selectedCategory.toLowerCase();

    if (widget.event != null) {
      final updatedEvent = widget.event!.copyWith(
        title: _titleController.text,
        startTime: start,
        endTime: end,
        category: category,
        colorValue: _selectedColor.toARGB32(),
        notes: _notesController.text.trim(),
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
        notes: _notesController.text.trim(),
      );
      ref.read(eventsProviderProvider.notifier).addEvent(event);
    }
    Navigator.pop(context);
  }
}
