import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/constants/variables.dart';

class ApplicationsLineChart extends StatelessWidget {
  final List<int> applicationCounts; // List of application counts for each day
  final List<String>
      dates; // List of dates corresponding to the application counts

  const ApplicationsLineChart({super.key, 
    required this.applicationCounts,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 2,
              verticalInterval: 2,
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: secondaryColor,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: secondaryColor,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    final dateIndex = value.toInt();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        dates[dateIndex],
                        style: const TextStyle(
                          fontWeight: poppinsRegular,
                          fontSize: smallFontSize,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontWeight: poppinsRegular,
                        fontSize: smallFontSize,
                      ),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: secondaryColor),
            ),
            minX: 0,
            maxX: dates.length - 1,
            minY: 0,
            maxY: applicationCounts.reduce((a, b) => a > b ? a : b).toDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  applicationCounts.length,
                  (index) => FlSpot(
                      index.toDouble(), applicationCounts[index].toDouble()),
                ),
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [
                    primaryColor,
                    primaryColor,
                  ],
                ),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: true,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 10,
                getTooltipColor: (touchedSpot) {
                  return primaryColor;
                },
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${dates[spot.x.toInt()]}\nApplications: ${spot.y.toInt()}',
                      const TextStyle(
                        color: Colors.white, // Text color inside tooltip
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
