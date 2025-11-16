import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String selectedCategory = "Food"; // default category

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Other",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void saveExpense() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter valid input")));
      return;
    }

    // generate a simple unique id (timestamp based)
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final expense = Expense(
      id: id,
      title: title,
      amount: amount,
      category: selectedCategory,
      date: DateTime.now(),
    );

    Hive.box<Expense>('expenses').put(expense.id, expense);

    Navigator.pop(context); // go back to home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Expense Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveExpense,
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
