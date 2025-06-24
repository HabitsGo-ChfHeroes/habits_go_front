import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EvolutionGraphic extends StatefulWidget {
  final List<int> data;

  const EvolutionGraphic({super.key, required this.data});

  @override
  State<EvolutionGraphic> createState() => _EvolutionGraphicState();
}

class _EvolutionGraphicState extends State<EvolutionGraphic> {
  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3)
  ];

  bool showData = false;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFE0E0E0),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Color(0xFFE0E0E0),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0.5,
        maxX: 7.5,
        minY: -0.5,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0.5, widget.data.isNotEmpty ? widget.data[0].toDouble() : 0),
              for (int i = 0; i < widget.data.length; i++)
                FlSpot((i + 1).toDouble(), widget.data[i].toDouble()),
              FlSpot(7.5, widget.data.isNotEmpty ? widget.data[6].toDouble() : 0),
            ],
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value != value.toInt()) {
      return const SizedBox.shrink();
    }
  
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('LUN', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('MIE', style: style);
        break;
      case 4:
        text = const Text('JUE', style: style);
        break;
      case 5:
        text = const Text('VIE', style: style);
        break;
      case 6:
        text = const Text('SAB', style: style);
        break;
      case 7:
        text = const Text('DOM', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }
}