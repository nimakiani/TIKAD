import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks/data/todos_model.dart';

class TodoDetailPage extends StatefulWidget {
  final Todomodel todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late TextEditingController _controller;
  late bool _isChecked;
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.todo);
    _isChecked = widget.todo.chek;
    _isBookmarked = widget.todo.isSave;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.todo.todo = _controller.text.trim();
    widget.todo.chek = _isChecked;
    widget.todo.isSave = _isBookmarked;
    widget.todo.save(); // Save to Hive

    Navigator.pop(context, true); // Return and refresh previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Row

              const SizedBox(height: 24),

              // Task Text Field
              const Text(
                'Task',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Write your task here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // Due Date
              if (widget.todo.dueDate != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            DateFormat(
                              'EEEE, d MMMM yyyy',
                            ).format(widget.todo.dueDate!),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
