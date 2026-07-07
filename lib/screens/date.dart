import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tasks/data/setting_model.dart';
import 'package:tasks/data/todos_model.dart';
import 'package:tasks/utils/vibration.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({super.key});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  VoidCallback? onTaskAdded;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    initializeDateFormatting();
  }

  // اضافه کردن تسک برای روز انتخاب شده
  void _addTaskForSelectedDay() async {
    if (_selectedDay == null) return;

    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'New Task for ${DateFormat('d MMMM yyyy').format(_selectedDay!)}',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter  The Text...',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                // ارسال تاریخ انتخاب شده به متد addTodo
                _addTodo(text, _selectedDay!);
                Navigator.pop(context);
                onTaskAdded?.call();
                vibratin();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // اصلاح متد addTodo با اضافه کردن dueDate
   void _addTodo(String text, DateTime dueDate) async {
    final box = Hive.box<Todomodel>('todobox');
    final newTodo = Todomodel(
      todo: text,
      chek: false,
      isSave: false,
      dueDate: _selectedDay, // حالا تاریخ انتخاب شده رو به dueDate اختصاص میدیم
    );

    int generatedKey = await box.add(newTodo);
    newTodo.key = generatedKey;
    await box.put(generatedKey, newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Hive.box<SettingModel>('settingbox').get('settings')?.isdark ?? true;

    final bgColor = isDark ? const Color(0xFF0F0F1E) : Colors.grey.shade50;
    final glassColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.75);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.15)
        : Colors.black.withOpacity(0.1);
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;
    final accentColor = Colors.blue;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      floatingActionButton: _selectedDay != null
          ? FloatingActionButton(
              onPressed: _addTaskForSelectedDay,
              child: const Icon(Icons.add),
              tooltip: 'Add Task',
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: borderColor, width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2035, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        color: textColor,
                        fontSize: 16.5,
                      ),
                      weekendTextStyle: TextStyle(
                        color: isDark ? Colors.pinkAccent : Colors.red,
                        fontSize: 16.5,
                      ),
                      outsideTextStyle: TextStyle(color: secondaryText),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2.5),
                      ),
                      todayTextStyle: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      cellMargin: const EdgeInsets.all(6),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: secondaryText,
                        size: 32,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: secondaryText,
                        size: 32,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                      weekendStyle: TextStyle(
                        color: isDark ? Colors.pinkAccent : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
