// lib/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firestore_services.dart';
import '../models/truck.dart';
import '../models/maintenance.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Truck & Maintenance Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  // Truck Count
                  Expanded(
                    child: StreamBuilder<List<Truck>>(
                      stream: firestore.getTrucks(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final truckCount = snapshot.data!.length;

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text('Total Trucks',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Text('$truckCount',
                                    style: const TextStyle(
                                        fontSize: 36, color: Colors.blue)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Monthly Maintenance Costs
                  Expanded(
                    child: StreamBuilder<List<Maintenance>>(
                      stream: firestore.getAllMaintenance(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final maintenance = snapshot.data!;

                        final monthlyCosts = <String, double>{};

                        for (var m in maintenance) {
                          final month =
                              '${m.date.year.toString().padLeft(4, '0')}-${m.date.month.toString().padLeft(2, '0')}';
                          monthlyCosts[month] =
                              (monthlyCosts[month] ?? 0) + m.cost;
                        }

                        final sortedMonths = monthlyCosts.keys.toList()..sort();

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text('Monthly Maintenance Costs',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: (monthlyCosts.values.isEmpty
                                          ? 100
                                          : monthlyCosts.values.reduce(
                                                  (a, b) => a > b ? a : b) *
                                              1.2),
                                      barTouchData: BarTouchData(enabled: true),
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final idx = value.toInt();
                                              if (idx < 0 ||
                                                  idx >= sortedMonths.length) {
                                                return const SizedBox();
                                              }
                                              return Text(sortedMonths[idx],
                                                  style: const TextStyle(
                                                      fontSize: 10));
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: true)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      barGroups: [
                                        for (int i = 0;
                                            i < sortedMonths.length;
                                            i++)
                                          BarChartGroupData(
                                            x: i,
                                            barRods: [
                                              BarChartRodData(
                                                toY: monthlyCosts[
                                                    sortedMonths[i]]!,
                                                color: Colors.orange,
                                                width: 16,
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

