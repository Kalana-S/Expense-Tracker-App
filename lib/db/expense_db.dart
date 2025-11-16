import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseDB {
  static const String boxName = 'expenseBox';

  // Open box
  static Future<Box<Expense>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Expense>(boxName);
    }
    return Hive.box<Expense>(boxName);
  }

  // Add Expense
  static Future<void> addExpense(Expense expense) async {
    final box = await _openBox();
    await box.put(expense.id, expense);
  }

  // Get all expenses
  static Future<List<Expense>> getExpenses() async {
    final box = await _openBox();
    return box.values.toList();
  }

  // Delete expense
  static Future<void> deleteExpense(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
