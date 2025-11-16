import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpensesPieChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensesPieChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text("No data to display"));
    }

    // Calculate total spending
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    // Group by category
    final Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 45,
          sections: categoryTotals.entries.map((entry) {
            final percentage = (entry.value / total) * 100;

            return PieChartSectionData(
              value: entry.value,
              title: "${percentage.toStringAsFixed(1)}%",
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
