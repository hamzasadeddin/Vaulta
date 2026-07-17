import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/dashboard/domain/entities/balance_point.dart';

/// Balance-history sparkline: no axes, no grid, no touch — shape only,
/// colored by trend direction.
class BalanceSparkline extends StatelessWidget {
  const BalanceSparkline({
    required this.points,
    this.height = 56,
    super.key,
  }) : assert(points.length >= 2, 'A sparkline needs at least two points');

  final List<BalancePoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Chart geometry only. This BigInt→double conversion draws pixels and
    // never re-enters money arithmetic (Decimal stays the money type).
    final values = [
      for (final point in points) point.balance.minorUnits.toDouble(),
    ];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final pad = high == low ? high.abs() * 0.1 + 1 : (high - low) * 0.15;
    final trendUp = values.last >= values.first;
    final color = trendUp ? context.colors.credit : context.colors.debit;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (values.length - 1).toDouble(),
          minY: low - pad,
          maxY: high + pad,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
              isCurved: true,
              curveSmoothness: 0.3,
              preventCurveOverShooting: true,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.28),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
