import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tatbeeqi/core/utils/notes_colors.dart';
import 'package:tatbeeqi/core/widgets/custom_markdown_body_widget.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';

class AddOrUpdateNoteView extends StatefulWidget {
  final Note? note;
  final String courseId;

  const AddOrUpdateNoteView({super.key, this.note, required this.courseId});

  @override
  State<AddOrUpdateNoteView> createState() => _AddOrUpdateNoteViewState();
}

class _AddOrUpdateNoteViewState extends State<AddOrUpdateNoteView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  int _selectedColorIndex = 0;
  bool _isPreview = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
    if (widget.note != null) {
      _selectedColorIndex = widget.note!.colorIndex;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final noteToSave = Note(
      id: widget.note?.id,
      courseId: widget.note?.courseId ?? widget.courseId,
      title: title,
      content: content,
      colorIndex: _selectedColorIndex,
      lastModified: DateTime.now(),
    );

    if (widget.note == null) {
      context.read<NotesBloc>().add(AddNoteEvent(noteToSave));
    } else {
      context.read<NotesBloc>().add(UpdateNoteEvent(noteToSave));
    }

    Navigator.of(context).pop();
  }

  void _deleteNote() {
    if (widget.note != null) {
      context.read<NotesBloc>().add(DeleteNoteEvent(
            noteId: widget.note!.id!,
            courseId: widget.note!.courseId,
          ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Color> currentNoteColors =
        isDarkMode ? AppColors.darkNoteColors : AppColors.lightNoteColors;
    final isNewNote = widget.note == null;
    return Scaffold(
      backgroundColor: currentNoteColors[_selectedColorIndex],
      appBar: AppBar(
        backgroundColor: currentNoteColors[_selectedColorIndex],
        title: Text(isNewNote ? 'ملاحظة جديدة' : 'تعديل'),
        actions: [
          IconButton(
            icon: Icon(_isPreview ? Icons.visibility_off : Icons.visibility),
            tooltip: _isPreview ? 'Hide Preview' : 'Show Markdown Preview',
            color: colorScheme.primary,
            onPressed: () {
              setState(() {
                _isPreview = !_isPreview;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            color: colorScheme.primary,
            tooltip: 'Save',
            onPressed: _saveNote,
          ),
          if (!isNewNote)
            IconButton(
              icon: const Icon(Icons.delete),
              color: colorScheme.error,
              tooltip: 'Delete',
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isPreview,
                    ),
                    const SizedBox(height: 8),
                    if (_isPreview)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomMarkDownBodyWidget(
                          data: _contentController.text.isEmpty
                              ? '*No content*'
                              : _contentController.text,
                        ),
                      )
                    else
                      TextField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          hintText: 'Note content...',
                          border: InputBorder.none,
                        ),
                        maxLines: null, // Allows for multiline input
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    if (!isNewNote)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colorScheme.primaryContainer,
                          ),
                          child: Text(
                            'اخر تعديل: ${DateFormat.yMMMd().add_jm().format(widget.note!.lastModified)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildColorSelector(currentNoteColors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(List<Color> currentNoteColors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: currentNoteColors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final color = currentNoteColors[index];
              final isSelected = index == _selectedColorIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: color,
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
