import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../widgets/expenses_pie_chart.dart';
import '../widgets/expenses_daily_bar_chart.dart';
import '../db/expense_db.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Expense>('expenses');

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Expense> b, _) {
          final expenses = b.values.toList().cast<Expense>();

          final total = expenses.fold<double>(0.0, (s, e) => s + e.amount);

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.green.shade50,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Total this week: Rs ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpensesPieChart(expenses: expenses),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ExpensesDailyBarChart(expenses: expenses),
                ),

                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final e = expenses[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(e.title),
                        subtitle: Text(
                          '${e.category} • ${e.date.toString().split(' ')[0]}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Rs ${e.amount.toStringAsFixed(2)}'),
                            const SizedBox(width: 10),

                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/edit-expense',
                                  arguments: e,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Expense"),
                                    content: Text(
                                      "Are you sure you want to delete '${e.title}'?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await ExpenseDB.deleteExpense(e.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
