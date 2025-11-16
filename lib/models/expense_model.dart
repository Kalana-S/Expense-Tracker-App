import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // convenience getter to get weekday name (e.g. "Monday")
  String get weekday => DateFormat('EEEE').format(date);
}
