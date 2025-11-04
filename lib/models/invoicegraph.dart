import 'package:billit/models/product_db_data.dart' show InvoiceSummary;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class InvoiceSummaryChart extends StatelessWidget {
  final List<InvoiceSummary> summary;

  const InvoiceSummaryChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Invoice Totals",
              style: TextStyle(fontSize: 20)
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true,reservedSize: 50),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index < 0 && index >= summary.length) {
                            //return Text(summary[index].month);
                            return const Text('');
                          }
                          return Text(
                            summary[index].month ?? '',
                            style: const TextStyle(fontSize: 10),
                          );
                          
                        },
                      ),
                    ),
                  ),
                  barGroups: summary
                      .asMap()
                      .entries
                      .map((e) => BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.total,
                                width: 16,
                                color: Colors.green,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
