import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseDB {
  static const String boxName = 'expenses';

  static Future<Box<Expense>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Expense>(boxName);
    }
    return Hive.box<Expense>(boxName);
  }

  static Future<void> addExpense(Expense expense) async {
    final box = await _openBox();
    await box.put(expense.id, expense);
  }

  static Future<List<Expense>> getExpenses() async {
    final box = await _openBox();
    return box.values.toList().cast<Expense>();
  }

  static Future<void> deleteExpense(String id) async {
    final box = await _openBox();
    if (box.containsKey(id)) {
      await box.delete(id);
    }
  }

  static Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
