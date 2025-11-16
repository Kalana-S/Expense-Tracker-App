import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../widgets/expenses_pie_chart.dart';
import '../widgets/expenses_daily_bar_chart.dart';
import 'add_expense_screen.dart';

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
                // Total
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

                // Pie chart (category distribution for the week)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpensesPieChart(expenses: expenses),
                ),

                // Daily bar chart (Mon - Sun). Interactive.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ExpensesDailyBarChart(expenses: expenses),
                ),

                const SizedBox(height: 12),

                // Expense list below
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
                        trailing: Text('Rs ${e.amount.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
