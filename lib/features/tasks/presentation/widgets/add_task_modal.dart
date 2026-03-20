import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../shared/widgets/auth_text_field.dart';
import '../../../../shared/widgets/color_picker_widget.dart';
import '../../domain/task_model.dart';
import '../tasks_provider.dart';

class AddTaskModal extends ConsumerStatefulWidget {
  final TaskModel? task;
  const AddTaskModal({super.key, this.task});

  @override
  ConsumerState<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends ConsumerState<AddTaskModal> {
  final _titleController = TextEditingController();
  late TaskPriority _priority;
  late DateTime _dueDate;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    } else {
      _priority = TaskPriority.medium;
      _dueDate = DateTime.now().add(const Duration(days: 1));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.task != null) {
      _selectedColor = Color(widget.task!.colorValue);
    } else {
      _selectedColor = Theme.of(context).appTheme.taskAccentDefault;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).appTheme.primary,
              brightness: Theme.of(context).brightness,
              surface: Theme.of(context).appTheme.surface,
              onSurface: Theme.of(context).appTheme.textPrimary,
              primary: Theme.of(context).appTheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );
      if (!mounted) return;
      if (time != null) {
        setState(() {
          _dueDate = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    try {
      if (widget.task != null) {
        final updatedTask = widget.task!.copyWith(
          title: title,
          priority: _priority,
          colorValue: _selectedColor.toARGB32(),
          dueDate: _dueDate,
        );
        await ref.read(tasksProviderProvider.notifier).updateTask(updatedTask);
      } else {
        await ref.read(tasksProviderProvider.notifier).addTask(
              title: title,
              priority: _priority,
              colorValue: _selectedColor.toARGB32(),
              dueDate: _dueDate,
            );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: theme.surface.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: theme.borderSecondary,
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.all(theme.spacingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.task != null ? 'Edit Task' : 'New Task',
                          style: theme.displayLarge.copyWith(fontSize: 28),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: theme.textPrimary),
                        ),
                      ],
                    ),
                    SizedBox(height: theme.spacingXL),
                    AuthTextField(
                      label: 'Task Title',
                      hint: 'What needs to be done?',
                      controller: _titleController,
                      prefixIcon: Icon(Icons.edit_note_rounded, color: theme.primary),
                    ),
                    SizedBox(height: theme.spacingLG),
                    
                    // Due Date Picker
                    Text(
                      'Due Date',
                      style: theme.labelSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
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
                              DateFormat('MMM dd, yyyy - hh:mm a').format(_dueDate),
                              style: theme.bodyMedium,
                            ),
                            const Spacer(),
                            Icon(Icons.edit, size: 16, color: theme.textHint),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: theme.spacingLG),
                    Text(
                      'Priority',
                      style: theme.labelSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<TaskPriority>(
                      segments: const [
                        ButtonSegment(
                          value: TaskPriority.low,
                          label: Text('Low'),
                          icon: Icon(Icons.low_priority, size: 18),
                        ),
                        ButtonSegment(
                          value: TaskPriority.medium,
                          label: Text('Medium'),
                          icon: Icon(Icons.density_medium, size: 18),
                        ),
                        ButtonSegment(
                          value: TaskPriority.high,
                          label: Text('High'),
                          icon: Icon(Icons.priority_high, size: 18),
                        ),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (Set<TaskPriority> selected) {
                        setState(() => _priority = selected.first);
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor: theme.surface,
                        selectedBackgroundColor: theme.primary,
                        selectedForegroundColor: theme.surface,
                      ),
                    ),
                    SizedBox(height: theme.spacingLG),
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
                    SizedBox(height: theme.spacingXL),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: theme.surface,
                        padding: EdgeInsets.symmetric(vertical: theme.spacingMD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(theme.radiusMD),
                        ),
                        elevation: 8,
                        shadowColor: theme.primary.withValues(alpha: 0.4),
                      ),
                      onPressed: _submit,
                      child: Text(
                        widget.task != null ? 'Update Task' : 'Add Task',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: theme.spacingXL),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

