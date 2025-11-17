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

    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    int colorIndex = 0;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 40,
              sections: categoryTotals.entries.map((entry) {
                final percentage = (entry.value / total) * 100;

                final color = colors[colorIndex % colors.length];
                colorIndex++;

                return PieChartSectionData(
                  color: color,
                  value: entry.value,
                  radius: 60,
                  title: "${entry.key}\n${percentage.toStringAsFixed(1)}%",
                  titleStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: categoryTotals.entries.map((entry) {
            final color =
                colors[categoryTotals.keys.toList().indexOf(entry.key) %
                    colors.length];

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 14, height: 14, color: color),
                const SizedBox(width: 6),
                Text(entry.key),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
