import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  LineChartWidget(
      {super.key,
      required this.monthlySales,
      required this.hasPrevious,
      required this.year});
  final Map<String, dynamic> monthlySales;
  final bool hasPrevious;
  final int year;

  final List<Color> gradientColors = [Colors.black, Colors.green];

  double getMaxSale(Map<String, dynamic> sales) {
    double max = 0.0;

    sales.forEach((key, value) {
      if (max < value) {
        max = value;
      }
    });

    return max < 5 ? 5 : max;
  }

  @override
  Widget build(BuildContext context) {
    return hasPrevious
        ? FutureBuilder<Map<String, dynamic>>(
            future: AnalyticsServices().getMonthlySales(year),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const SizedBox(
                  height: 220,
                  child: Center(
                    child: Loading(),
                  ),
                );
              }

              final previousSales = snapshot.data;
              final List<double> previousMonthlySales = [];
              previousSales?.forEach((key, value) {
                previousMonthlySales.add(value);
              });

              final withPreviousSales = monthlySales;
              withPreviousSales['0'] = previousMonthlySales.average;

              double highestSale = getMaxSale(withPreviousSales);

              int length = highestSale.toInt().toString().length;

              double tmp = int.parse("1${"0" * length}") / 5;

              List<FlSpot> flSpots = [];

              for (int i = 0; i < 12; i++) {
                var x = i;

                if (monthlySales.containsKey(i.toString())) {
                  var y = monthlySales[i.toString()]! / tmp;
                  flSpots.add(FlSpot(x.toDouble(), y));
                } else {
                  flSpots.add(FlSpot(x.toDouble(), 0));
                }
              }

              return SizedBox(
                height: 220,
                child: LineChart(
                  duration: const Duration(milliseconds: 250),
                  LineChartData(
                    lineTouchData: _lineTouchData(tmp),
                    titlesData: _titlesData(tmp),
                    showingTooltipIndicators: [],
                    minX: 0,
                    maxX: 12,
                    minY: 0,
                    maxY: 5,
                    // titlesData: LineTitles,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          // const FlSpot(0, 5),

                          ...flSpots,
                        ],
                        isCurved: false,
                        isStrokeCapRound: true,
                        color: const Color(0xff3DD598),
                        barWidth: 5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xff3DD598).withOpacity(0.3)),
                      )
                    ],
                  ),
                ),
              );
            })
        : Builder(builder: (context) {
            double highestSale = getMaxSale(monthlySales);

            int length = highestSale.toInt().toString().length;

            double tmp = int.parse("1${"0" * length}") / 5;

            // print(monthlySales.containsKey(1));

            List<FlSpot> flSpots = [];

            for (int i = 1; i < 13; i++) {
              var x = i;

              if (monthlySales.containsKey(i.toString())) {
                var y = monthlySales[i.toString()]! / tmp;
                flSpots.add(FlSpot(x.toDouble(), y));
              } else {
                flSpots.add(FlSpot(x.toDouble(), 0));
              }
            }
            return SizedBox(
                height: 220,
                child: LineChart(
                  duration: const Duration(milliseconds: 250),
                  LineChartData(
                    lineTouchData: _lineTouchData(tmp),
                    titlesData: _titlesData(tmp),
                    showingTooltipIndicators: [],
                    minX: 0,
                    maxX: 13,
                    minY: 0,
                    maxY: 5,
                    // titlesData: LineTitles,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          // const FlSpot(0, 5),

                          const FlSpot(0, 0),

                          ...flSpots,

                          // for (int i = 0; i < 12; i ++) ...[]
                          // const FlSpot(2, 0.90),
                          // const FlSpot(4, 3),
                          // const FlSpot(6, 4),
                          // const FlSpot(8, 4),
                          // const FlSpot(11, 3),
                          // const FlSpot(12, 3),
                        ],
                        isCurved: false,
                        isStrokeCapRound: true,
                        color: const Color(0xff3DD598),
                        barWidth: 5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xff3DD598).withOpacity(0.3)),
                      )
                    ],
                  ),
                ));
          });
  }

  FlTitlesData _titlesData(double value) => FlTitlesData(
      bottomTitles: _bottomTitles(),
      leftTitles: _leftTitles(value),
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles());

  AxisTitles _leftTitles(double tmp) => AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          const style = TextStyle(
            color: Color(0xFF92929D),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          );
          String text;
          switch (value.toInt()) {
            case 0:
              text = '0';
              break;
            case 1:
              text = NumberFormat.compact().format(tmp * 1);
              break;
            case 2:
              text = NumberFormat.compact().format(tmp * 2);
              break;
            case 3:
              text = NumberFormat.compact().format(tmp * 3);
              break;
            case 4:
              text = NumberFormat.compact().format(tmp * 4);
              break;
            case 5:
              text = NumberFormat.compact().format(tmp * 5);
              break;
            default:
              return Container();
          }

          return Text(
            text,
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          );
        },
      ));

  AxisTitles _bottomTitles() => AxisTitles(
          sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          const style = TextStyle(
            color: Color(0xFF92929D),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          );
          Widget text;
          switch (value.toInt()) {
            case 1:
              text = const Text('JAN', style: style);
              break;
            case 3:
              text = const Text('MAR', style: style);
              break;
            case 5:
              text = const Text('MAY', style: style);
              break;
            case 7:
              text = const Text('JULY', style: style);
              break;
            case 9:
              text = const Text('SEP', style: style);
              break;
            case 11:
              text = const Text('NOV', style: style);
              break;

            default:
              text = const Text('');
              break;
          }

          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 10,
            child: text,
          );
        },
      ));

  LineTouchData _lineTouchData(double value) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final flSpot = touchedSpot.bar.spots[touchedSpot.spotIndex];
              String tooltipLabel =
                  '₱${(flSpot.y * value).toStringAsFixed(0)} \n${(flSpot.x == 0.0) ? "Last Year" : DateFormat('MMMM').format(DateTime(0, flSpot.x.toInt()))}';
              return LineTooltipItem(
                tooltipLabel,
                const TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          }),
    );
  }
}
