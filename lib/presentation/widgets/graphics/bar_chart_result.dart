import 'package:encuestas_app/answer/answer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartResult extends StatelessWidget {
  final List<Answer> answers;

  const BarChartResult({Key? key, required this.answers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> barColors = [const Color(0xFF3e4d6a), const Color(0xFF648fe4)];
    int colorIndex = 0;

    final List<BarChartGroupData> barGroups =
        answers.asMap().entries.map((entry) {
      final index = entry.key;
      final answerData = entry.value;
      final count = answerData.count;

      // Aquí puedes definir la lógica para asignar colores basados en algún criterio
      final currentColor = barColors[colorIndex];
      colorIndex = (colorIndex + 1) % barColors.length; // Alterna entre 0 y 1

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          toY: count!.toDouble(),
          width: 25,
          color: currentColor,
          borderRadius: BorderRadius.circular(0),
        )
      ]);
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 40, 10),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: true)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta metaData) {
                    if (value >= 0 && value < answers.length) {
                      final answer = answers[value.toInt()].answer;
                      return Text(
                        answer,
                        style: const TextStyle(
                          color: Color(0xFF7F8691),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }
}
