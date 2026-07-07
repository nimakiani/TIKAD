// add_todo_dialog.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/utils/vibration.dart';
import 'package:intl/intl.dart';

class AddTodoDialog extends StatefulWidget {
  final VoidCallback? onTaskAdded;
  final DateTime? selectedDate;
  final ValueNotifier<int>? refreshNotifier; // اضافه کردن ValueNotifier

  const AddTodoDialog({
    super.key,
    this.onTaskAdded,
    this.selectedDate,
    this.refreshNotifier,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onTaskAdded,
    DateTime? selectedDate,
    ValueNotifier<int>? refreshNotifier,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        onTaskAdded: onTaskAdded,
        selectedDate: selectedDate,
        refreshNotifier: refreshNotifier,
      ),
    );
  }
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addTodo() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final box = Hive.box<Todomodel>('todobox');
      final dueDate = widget.selectedDate ?? DateTime.now();

      final newTodo = Todomodel(
        todo: text,
        chek: false,
        isSave: false,
        dueDate: dueDate,
      );

      int generatedKey = await box.add(newTodo);
      newTodo.key = generatedKey;
      await box.put(generatedKey, newTodo);
      newTodo.save();
      vibratin();

      // بروزرسانی با ValueNotifier
      if (widget.refreshNotifier != null) {
        widget.refreshNotifier!.value++;
      }

      // فراخوانی callback
      widget.onTaskAdded?.call();

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.add_task, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Add Task'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectedDate != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE, d MMMM yyyy',
                    ).format(widget.selectedDate!),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter The Text...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            autofocus: true,
            maxLines: 3,
            onSubmitted: (_) => _addTodo(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addTodo,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
