import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
      future: DatabaseHelper.instance.monthlySales(),
      builder: (context, snapshot) {
        final values = snapshot.data ?? List<double>.filled(6, 0);
        final maxValue = values.fold<double>(100, (a, b) => a > b ? a : b) * 1.2;
        return ListView(padding: const EdgeInsets.all(16), children: [
          const Text('لوحة التحكم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, num>>(future: DatabaseHelper.instance.summary(), builder: (context, summary) {
            final x = summary.data ?? <String, num>{};
            return Wrap(spacing: 10, runSpacing: 10, children: [_card('إجمالي المبيعات', '${(x['sales'] ?? 0).toStringAsFixed(2)} ر.س', Icons.trending_up), _card('إجمالي المشتريات', '${(x['purchases'] ?? 0).toStringAsFixed(2)} ر.س', Icons.shopping_cart), _card('عدد العملاء', '${x['customers'] ?? 0}', Icons.people), _card('صافي الربح', '${(x['profit'] ?? 0).toStringAsFixed(2)} ر.س', Icons.account_balance_wallet)]);
          }),
          const SizedBox(height: 20),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: SizedBox(height: 230, child: LineChart(LineChartData(maxY: maxValue, minY: 0, gridData: const FlGridData(show: true), titlesData: const FlTitlesData(rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))), lineBarsData: [LineChartBarData(isCurved: true, color: const Color(0xFF0D47A1), barWidth: 3, spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])])])))),
          const SizedBox(height: 10),
          const Text('مبيعات آخر 6 شهور', textAlign: TextAlign.center),
        ]);
      },
    );
  }
  Widget _card(String title, String value, IconData icon) => SizedBox(width: 175, child: Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFF0D47A1)), const SizedBox(height: 8), Text(title), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))]))));
}
