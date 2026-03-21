import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../domain/models/calendar_event_model.dart';
import 'providers/events_provider.dart';
import 'widgets/add_event_modal.dart';

class EventDetailScreen extends ConsumerWidget {
  final CalendarEventModel event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    final eventsAsync = ref.watch(eventsProviderProvider);

    // Watch for updates to the specific event
    final currentEvent = eventsAsync.maybeWhen(
      data: (events) => events.firstWhere(
        (e) => e.id == event.id,
        orElse: () => event,
      ),
      orElse: () => event,
    );

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.primary),
            onPressed: () => _showEditModal(context, currentEvent),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.error),
            onPressed: () => _confirmDelete(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(currentEvent, theme),
              const SizedBox(height: 32),
              _buildTimeSection(currentEvent, theme),
              const SizedBox(height: 32),
              if (currentEvent.notes != null && currentEvent.notes!.isNotEmpty)
                _buildNotesSection(currentEvent.notes!, theme),
              const SizedBox(height: 100), // Space for bottom actions
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildBottomActions(context, ref, currentEvent, theme),
    );
  }

  Widget _buildHeader(CalendarEventModel event, AppThemeExtension theme) {
    final color = event.colorValue != null ? Color(event.colorValue!) : theme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(event.category),
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                event.category.toUpperCase(),
                style: theme.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          event.title,
          style: theme.displayLarge.copyWith(
            fontSize: 32,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(CalendarEventModel event, AppThemeExtension theme) {
    final color = event.colorValue != null ? Color(event.colorValue!) : theme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.borderSecondary, width: 1),
      ),
      child: Column(
        children: [
          _buildTimeRow(
            icon: Icons.access_time_filled_rounded,
            label: 'Start Time',
            time: DateFormat('EEEE, MMM d • h:mm a').format(event.startTime),
            theme: theme,
            iconColor: color,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: theme.borderSecondary, height: 1),
          ),
          _buildTimeRow(
            icon: Icons.history_rounded,
            label: 'End Time',
            time: DateFormat('EEEE, MMM d • h:mm a').format(event.endTime),
            theme: theme,
            iconColor: theme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required String time,
    required AppThemeExtension theme,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.labelSmall),
            const SizedBox(height: 4),
            Text(
              time,
              style: theme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes, AppThemeExtension theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description / Notes', style: theme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderSecondary, width: 1),
          ),
          child: Text(
            notes,
            style: theme.bodyMedium.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref, CalendarEventModel event, AppThemeExtension theme) {
    final bool isCompleted = event.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: theme.borderSecondary, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                onPressed: () {
                  ref.read(eventsProviderProvider.notifier).toggleEventCompletion(event.id);
                },
                icon: isCompleted ? Icons.restart_alt_rounded : Icons.check_circle_rounded,
                label: isCompleted ? 'Reopen Event' : 'Mark Completed',
                color: isCompleted ? theme.primary : theme.success,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, CalendarEventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventModal(
        event: event,
        initialDate: event.startTime,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).appTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Event', style: theme.titleLarge),
        content: Text(
          'Are you sure you want to delete this event? This action cannot be undone.',
          style: theme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: theme.labelLarge),
          ),
          TextButton(
            onPressed: () {
              ref.read(eventsProviderProvider.notifier).deleteEvent(event.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to calendar screen
            },
            child: Text('Delete', style: theme.labelLarge.copyWith(color: theme.error)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'meeting':
        return Icons.group_rounded;
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'personal':
        return Icons.person_rounded;
      default:
        return Icons.event_rounded;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final AppThemeExtension theme;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.titleSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
