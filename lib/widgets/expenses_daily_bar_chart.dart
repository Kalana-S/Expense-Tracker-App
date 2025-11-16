import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';

class ExpensesDailyBarChart extends StatelessWidget {
  final List<Expense> expenses;
  const ExpensesDailyBarChart({super.key, required this.expenses});

  // ordered weekday list starting with Monday
  static const List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // group expenses by weekday (Monday..Sunday)
  Map<String, List<Expense>> _groupByWeekday() {
    final map = {for (var d in weekdays) d: <Expense>[]};
    for (var e in expenses) {
      final day = DateFormat('EEEE').format(e.date);
      if (!map.containsKey(day)) {
        map[day] = [e];
      } else {
        map[day]!.add(e);
      }
    }
    return map;
  }

  // get totals list in same order as weekdays
  List<double> _dailyTotals(Map<String, List<Expense>> grouped) {
    return weekdays.map((d) {
      final list = grouped[d] ?? [];
      return list.fold(0.0, (s, x) => s + x.amount);
    }).toList();
  }

  // helper to show bottom sheet with day details
  void _showDayDetails(BuildContext context, String day, List<Expense> list) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final dayTotal = list.fold(0.0, (s, x) => s + x.amount);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$day — ${list.length} item(s) • Total: Rs ${dayTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final e = list[index];
                      return ListTile(
                        title: Text(e.title),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd – HH:mm').format(e.date),
                        ),
                        trailing: Text('Rs ${e.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByWeekday();
    final totals = _dailyTotals(grouped);
    final maxY = (totals.isEmpty)
        ? 100.0
        : (totals.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
            10.0,
            double.infinity,
          );

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (response == null || response.spot == null) return;
                    final groupIndex = response.spot!.touchedBarGroupIndex;
                    if (groupIndex < 0 || groupIndex >= weekdays.length) return;
                    final day = weekdays[groupIndex];
                    final list = grouped[day] ?? [];
                    _showDayDetails(context, day, list);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= weekdays.length)
                          return const SizedBox.shrink();
                        final short = weekdays[idx].substring(
                          0,
                          3,
                        ); // Mon, Tue...
                        return SideTitleWidget(
                          child: Text(short),
                          axisSide: meta.axisSide,
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(weekdays.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: totals[i],
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
