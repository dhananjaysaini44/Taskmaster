import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../domain/mind_note.dart';
import 'providers/mind_notes_provider.dart';

class MindMapScreen extends ConsumerStatefulWidget {
  const MindMapScreen({super.key});

  @override
  ConsumerState<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends ConsumerState<MindMapScreen> {
  late TextEditingController _notesController;
  MindNote? _editingNote;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    final content = _notesController.text.trim();
    if (content.isEmpty) return;

    if (_editingNote != null) {
      ref.read(mindNotesProvider.notifier).updateNote(
            _editingNote!.copyWith(content: content),
          );
      setState(() {
        _editingNote = null;
        _notesController.clear();
      });
    } else {
      ref.read(mindNotesProvider.notifier).addNote(content);
      _notesController.clear();
    }
    
    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  void _onEdit(MindNote note) {
    setState(() {
      _editingNote = note;
      _notesController.text = note.content;
    });
    // Optional: Scroll to top? Or just let user type.
  }

  void _onDelete(String id) {
    ref.read(mindNotesProvider.notifier).deleteNote(id);
    if (_editingNote?.id == id) {
      setState(() {
        _editingNote = null;
        _notesController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final notesAsync = ref.watch(mindNotesProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: theme.spacingXL * 0.375),
          Text(
            'Mind Flow',
            style: theme.titleLarge.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: theme.textPrimary,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: theme.spacingXS),
          Text.rich(
            TextSpan(
              text: 'Your thoughts, ',
              children: [
                TextSpan(
                  text: 'organized.',
                  style: TextStyle(color: theme.primary),
                ),
              ],
            ),
            style: theme.bodyMedium.copyWith(
              color: theme.bodyMedium.color?.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: theme.spacingMD),
          
          // Note Editor Section
          _buildEditor(theme),
          
          SizedBox(height: theme.spacingLG),
          
          Text(
            'Recent Flows',
            style: theme.titleSmall.copyWith(
              color: theme.textSecondary,
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: theme.spacingSM),
          
          // Notes List Section
          Expanded(
            child: notesAsync.when(
              data: (notes) => notes.isEmpty 
                ? _buildEmptyState(theme)
                : ListView.separated(
                    padding: EdgeInsets.only(bottom: theme.spacingXL),
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => SizedBox(height: theme.spacingMD),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return _NoteCard(
                        note: note,
                        onEdit: () => _onEdit(note),
                        onDelete: () => _onDelete(note.id),
                        theme: theme,
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(AppThemeExtension theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacingMD),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(theme.radiusLG),
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: _notesController,
            maxLines: 4,
            style: theme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              hintStyle: theme.bodyMedium.copyWith(
                color: theme.labelSmall.color?.withValues(alpha: 0.3),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(height: theme.spacingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_editingNote != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _editingNote = null;
                      _notesController.clear();
                    });
                  },
                  child: Text('Cancel', style: TextStyle(color: theme.error)),
                )
              else
                const SizedBox.shrink(),
              ElevatedButton.icon(
                onPressed: _onSave,
                icon: Icon(_editingNote != null ? Icons.check : Icons.add_rounded, size: 18),
                label: Text(_editingNote != null ? 'Update Flow' : 'Save Flow'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.radiusMD),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacingLG,
                    vertical: theme.spacingSM,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppThemeExtension theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub_outlined, size: 48, color: theme.textHint.withValues(alpha: 0.5)),
          SizedBox(height: theme.spacingMD),
          Text(
            'No mind flows yet',
            style: theme.bodyLarge.copyWith(color: theme.textHint),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final MindNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppThemeExtension theme;

  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.jm().format(note.createdAt);
    final dateStr = DateFormat.yMMMd().format(note.createdAt);

    return Container(
      padding: EdgeInsets.all(theme.spacingMD),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(theme.radiusMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.textHint.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$dateStr at $timeStr',
                style: theme.labelSmall.copyWith(
                  color: theme.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit_outlined, size: 18, color: theme.primary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: theme.spacingMD),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline, size: 18, color: theme.error),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: theme.spacingSM),
          Text(
            note.content,
            style: theme.bodyMedium.copyWith(
              height: 1.5,
              color: theme.textPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
