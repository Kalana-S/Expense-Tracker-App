import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../db/expense_db.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController titleC;
  late TextEditingController amountC;
  late Expense expense;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Expense) {
      Navigator.pop(context);
      return;
    }

    expense = args as Expense;

    titleC = TextEditingController(text: expense.title);
    amountC = TextEditingController(text: expense.amount.toString());
  }

  @override
  void dispose() {
    titleC.dispose();
    amountC.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newTitle = titleC.text.trim();
    final newAmount = double.tryParse(amountC.text.trim());

    if (newTitle.isEmpty || newAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and amount')),
      );
      return;
    }

    final updated = expense.copyWith(
      title: newTitle,
      amount: newAmount,
      category: expense.category,
      date: expense.date,
    );

    await ExpenseDB.addExpense(updated);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Expense updated')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountC,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveChanges, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
