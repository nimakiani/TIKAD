import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/utils/todo_detail_page.dart';

class BookmarkedTasksPage extends StatefulWidget {
  const BookmarkedTasksPage({super.key});

  @override
  State<BookmarkedTasksPage> createState() => _BookmarkedTasksPageState();
}

class _BookmarkedTasksPageState extends State<BookmarkedTasksPage> {
  final box = Hive.box<Todomodel>('todobox');

  // دریافت تسک‌های بوک‌مارک شده
  List<Todomodel> get bookmarkedTodos {
    return box.values.where((todo) => todo.isSave == true).toList()
      ..sort((a, b) {
        // مرتب‌سازی بر اساس تاریخ (جدیدترین اول)
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return b.dueDate!.compareTo(a.dueDate!);
      });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Hive.box<SettingModel>('settingbox').get('settings')?.isdark ?? true;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F1E) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Bookmarked Tasks'),
        backgroundColor: isDark ? const Color(0xFF0F0F1E) : Colors.grey.shade50,
        elevation: 0,
        actions: [
          // نمایش تعداد بوک‌مارک‌ها
          ValueListenableBuilder<Box<Todomodel>>(
            valueListenable: box.listenable(),
            builder: (context, box, child) {
              final count = bookmarkedTodos.length;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Chip(
                    label: Text('$count'),
                    backgroundColor: Colors.amber.withOpacity(0.2),
                    labelStyle: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Todomodel>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          final todos = bookmarkedTodos;

          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarked tasks',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the star icon on any task to bookmark it',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoDetailPage(todo: todo),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {}); // بروزرسانی لیست بعد از بازگشت
                      }
                    });
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      child: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      todo.todo,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: todo.chek
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.chek ? Colors.grey : null,
                      ),
                    ),
                    subtitle: todo.dueDate != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat(
                                'EEEE, d MMMM yyyy',
                              ).format(todo.dueDate!),
                              style: const TextStyle(fontSize: 13),
                            ),
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(
                        todo.isSave ? Icons.star : Icons.star_border,
                        color: todo.isSave ? Colors.amber : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        todo.isSave = !todo.isSave;
                        todo.save(); // ذخیره در Hive
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
