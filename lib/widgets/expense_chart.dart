import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    final List<PieChartSectionData> sections =
        categoryTotals.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            title: entry.key,
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return PieChart(
      PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 30),
    );
  }
}
