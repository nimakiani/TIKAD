import 'package:hive/hive.dart';

part 'todos_model.g.dart';

@HiveType(typeId: 0)
class Todomodel extends HiveObject {
  @HiveField(0)
  String todo;

  @HiveField(1)
  bool chek;

  @HiveField(2)
  bool isSave;

  @HiveField(3)
  int? key;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5) 
  DateTime? dueDate;

  Todomodel({
    required this.todo,
    required this.chek,
    required this.isSave,
    this.key,
    DateTime? createdAt, // ← optional
    this.dueDate
  }) : this.createdAt = createdAt ?? DateTime.now();
}
