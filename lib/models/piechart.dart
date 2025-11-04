import 'package:billit/models/product_db_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class ProductPieChart extends StatefulWidget {
  final List<ProductSales> sales;

  const ProductPieChart({Key? key, required this.sales}) : super(key: key);

  @override
  State<ProductPieChart> createState() => _ProductPieChartState();
}

class _ProductPieChartState extends State<ProductPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        borderData: FlBorderData(show: false),
        sections: widget.sales.asMap().entries.map((entry) {
          final index = entry.key;
          final sale = entry.value;

          final isTouched = index == touchedIndex;
          final double fontSize = isTouched ? 18 : 14;
          final double radius = isTouched ? 70 : 60;

          return PieChartSectionData(
            color: Colors.primaries[index % Colors.primaries.length],
            value: sale.count.toDouble(),
            title: isTouched ? '${sale.count}' : sale.name,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = null;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
    );
  }
}
