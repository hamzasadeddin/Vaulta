import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaulta/core/money/money_formatter.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';

/// The grown-up sibling of the dashboard sparkline: axes, gridlines and
/// touch tooltips.
///
/// Plotting boundary rule (§5 of the handoff): `BigInt` minor units become
/// doubles for pixel geometry only and never re-enter money arithmetic.
/// Axis labels are compact-formatted gridline positions — geometry, not
/// money display; exact amounts surface in the tooltip via `Money`.
class BalanceHistoryChart extends StatelessWidget {
  const BalanceHistoryChart({
    required this.points,
    this.height = 220,
    super.key,
  }) : assert(points.length >= 2, 'A history chart needs at least 2 points');

  /// Chronological, oldest first.
  final List<BalancePoint> points;

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final values = [
      for (final point in points) point.balance.minorUnits.toDouble(),
    ];
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final pad = high == low ? high.abs() * 0.1 + 1 : (high - low) * 0.12;
    final minY = low - pad;
    final maxY = high + pad;
    final yInterval = (maxY - minY) / 4;
    final xInterval = math.max(1, (points.length - 1) ~/ 3).toDouble();

    final trendUp = values.last >= values.first;
    final lineColor = trendUp ? colors.credit : colors.debit;

    final currency = points.first.balance.currency;
    final minorDivisor = math.pow(10, currency.minorUnitDigits).toDouble();

    final spanDays = points.last.date.difference(points.first.date).inDays;
    final dateFormat =
        spanDays > 150 ? DateFormat('MMM yy') : DateFormat('d MMM');
    final axisStyle =
        context.textStyles.labelSmall?.copyWith(color: colors.textTertiary) ??
            TextStyle(fontSize: 10, color: colors.textTertiary);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: colors.border, strokeWidth: 0.6),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: yInterval,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: Text(
                    NumberFormat.compact().format(value / minorDivisor),
                    style: axisStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dateFormat.format(points[index].date),
                      style: axisStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => colors.surfaceRaised,
              getTooltipItems: (spots) => [
                for (final spot in spots) _tooltipItem(context, spot),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
              isCurved: true,
              curveSmoothness: 0.25,
              color: lineColor,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    lineColor.withValues(alpha: 0.22),
                    lineColor.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineTooltipItem _tooltipItem(BuildContext context, LineBarSpot spot) {
    final index = spot.x.round().clamp(0, points.length - 1);
    final point = points[index];
    return LineTooltipItem(
      point.balance.format(),
      context.typography.moneySm.copyWith(color: context.colors.textPrimary),
      children: [
        TextSpan(
          text: '\n${DateFormat('d MMM yyyy').format(point.date)}',
          style: context.textStyles.labelSmall
                  ?.copyWith(color: context.colors.textSecondary) ??
              const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
