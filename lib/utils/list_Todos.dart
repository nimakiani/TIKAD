import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:tasks/utils/playsaund.dart';
import 'package:tasks/utils/todo_detail_page.dart';
import 'package:tasks/utils/vibration.dart';

class My_todos extends StatefulWidget {
  const My_todos({super.key});

  @override
  State<My_todos> createState() => _My_todosState();
}

class _My_todosState extends State<My_todos> {
  var box = Hive.box<Todomodel>('todobox');

  // دریافت لیست زنده توده‌ها از باکس ورودی builder
  List<Todomodel> getTodos(Box<Todomodel> currentBox) =>
      currentBox.values.toList();

  // گروه‌بندی تسک‌ها بر اساس تاریخ اصلاح شده برای دریافت باکس زنده
  Map<DateTime, List<Todomodel>> getGroupedTodos(Box<Todomodel> currentBox) {
    final Map<DateTime, List<Todomodel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var todo in getTodos(currentBox)) {
      if (todo.dueDate != null) {
        final date = DateTime(
          todo.dueDate!.year,
          todo.dueDate!.month,
          todo.dueDate!.day,
        );

        if (!grouped.containsKey(date)) {
          grouped[date] = [];
        }
        grouped[date]!.add(todo);
      }
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == today) return -1;
        if (b == today) return 1;
        return b.compareTo(a);
      });

    final sortedMap = <DateTime, List<Todomodel>>{};
    for (var key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  OverlayEntry? _overlayEntry;
  bool _isAnimating = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _showFullScreenAnimation() {
    if (_isAnimating) return;
    _isAnimating = true;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildFullScreenAnimation(),
    );

    final overlay = Overlay.of(context);
    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(milliseconds: 2500), () {
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isAnimating = false;
    }
  }

  Widget _buildFullScreenAnimation() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(color: Colors.transparent),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/animations/explode.json',
                fit: BoxFit.contain,
                repeat: false,
                animate: true,
                frameRate: const FrameRate(60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(
    DateTime date,
    Map<DateTime, List<Todomodel>> grouped,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1)); // اصلاح شد
    final tomorrow = today.add(const Duration(days: 1)); // اصلاح شد

    String title;
    if (date == today) {
      title = 'Today';
    } else if (date == yesterday) {
      title = 'Yesterday';
    } else if (date == tomorrow) {
      title = 'Tomorrow';
    } else {
      title = DateFormat('d MMMM yyyy').format(date);
    }

    final tasksForDate = grouped[date] ?? [];
    final pendingTasks = tasksForDate.where((t) => !t.chek).length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$pendingTasks pending',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var settingBox = Hive.box<SettingModel>('settingbox');
    settingBox.get('settings');

    // لیسنر در بالاترین سطح قرار گرفت تا کل ساختار را مانیتور کند
    return ValueListenableBuilder<Box<Todomodel>>(
      valueListenable: box.listenable(),
      builder: (context, currentBox, child) {
        final currentTodos = getTodos(currentBox);

        // بررسی خالی بودن در هر تغییر دیتابیس
        if (currentTodos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/empty.json',
                    fit: BoxFit.cover,
                    repeat: true,
                    animate: true,
                    frameRate: const FrameRate(60),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You don\'t have to do anything.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Tap + to add a new task.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        }

        final grouped = getGroupedTodos(currentBox);

        return ListView.builder(
          itemCount: grouped.keys.length,
          itemBuilder: (context, index) {
            final date = grouped.keys.elementAt(index);
            final tasksForDate = grouped[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(date, grouped),
                ...tasksForDate.map((todo) {
                  final todoKey = todo.key ?? index;

                  return Column(
                    children: [
                      Slidable(
                        key: ValueKey(todoKey),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              final key = todo.key;
                              if (key != null) {
                                _deleteTodo(key);
                              }
                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                final key = todo.key;
                                if (key != null) {
                                  _deleteTodo(key);
                                }
                              },
                              icon: Icons.delete_outline,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TodoDetailPage(todo: todo),
                              ),
                            ).then((value) {
                              if (value == true) {
                                setState(() {});
                              }
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                width: double.infinity,
                                height: 80,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: todo.chek,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          todo.chek = newValue!;
                                          _deleteTodo(todo.key!);
                                          _showFullScreenAnimation();
                                          vibratin();
                                          playsaund();
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              todo.todo,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          todo.isSave = !todo.isSave;
                                          todo.save();
                                        });
                                      },
                                      icon: Icon(
                                        todo.isSave
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                      color: todo.isSave
                                          ? Colors.amber
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // تبدیل خط جداکننده زیر کارد به دکوراسیون ساده به جای استفاده از Positioned اشتباه
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 0.8,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white10,
                              Colors.white12,
                              Colors.white30,
                              Colors.white10,
                            ],
                            stops: [0.0, 0.1, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                if (index < grouped.keys.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTodo(int key) async {
    final box = Hive.box<Todomodel>('todobox');
    await box.delete(key);
  }
}
