import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/meal.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Meal> meals;

  const StatisticsScreen({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Статистика')),
        body: const Center(
          child: Text(
            'Недостаточно данных для отображения статистики',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // --- Группировка калорий по дате ---
    final Map<String, double> caloriesByDate = {};
    for (final meal in meals) {
      final dateKey = DateFormat('dd.MM').format(meal.date);
      caloriesByDate[dateKey] =
          (caloriesByDate[dateKey] ?? 0) + (meal.calories ?? 0);
    }

    final sortedDates = caloriesByDate.keys.toList()
      ..sort((a, b) =>
          DateFormat('dd.MM').parse(a).compareTo(DateFormat('dd.MM').parse(b)));

    final averageCalories =
        caloriesByDate.values.reduce((a, b) => a + b) / caloriesByDate.length;

    final lineSpots = List.generate(sortedDates.length, (index) {
      final date = sortedDates[index];
      return FlSpot(index.toDouble(), caloriesByDate[date]!);
    });

    final Map<String, double> caloriesByMeal = {};
    for (final meal in meals) {
      caloriesByMeal[meal.name] =
          (caloriesByMeal[meal.name] ?? 0) + (meal.calories ?? 0);
    }

    final topMeals = caloriesByMeal.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3 = topMeals.take(3).toList();

    final totalCalories = caloriesByDate.values.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Средняя калорийность: ${averageCalories.toStringAsFixed(0)} ккал',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Калорийность по дням',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              AspectRatio(
                aspectRatio: 1.7,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.black26),
                        left: BorderSide(color: Colors.black26),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 200,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= sortedDates.length) {
                              return const SizedBox.shrink();
                            }
                            return Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                sortedDates[index],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.25),
                        ),
                        dotData: FlDotData(show: true),
                        spots: lineSpots,
                      ),
                    ],
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Всего приёмов пищи: ${meals.length}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'Общее количество калорий: ${totalCalories.toStringAsFixed(0)} ккал',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),

              const Text(
                'Топ-3 самых калорийных блюда:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...top3.map(
                (entry) => ListTile(
                  leading: const Icon(Icons.local_dining, color: Colors.orange),
                  title: Text(entry.key),
                  trailing: Text('${entry.value.toStringAsFixed(0)} ккал'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
