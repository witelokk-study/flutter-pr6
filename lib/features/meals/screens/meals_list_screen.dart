import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_list_view.dart';

class MealsListScreen extends StatelessWidget {
  final List<Meal> meals;
  final DateTime selectedDate;
  final void Function(DateTime newDate) onDateChange;
  final VoidCallback onAdd;
  final void Function(Meal meal) onEdit;
  final void Function(String id) onDelete;

  const MealsListScreen({
    super.key,
    required this.meals,
    required this.selectedDate,
    required this.onDateChange,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories =
        meals.fold<double>(0, (sum, meal) => sum + (meal.calories ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник питания'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => onDateChange(
                    selectedDate.subtract(const Duration(days: 1)),
                  ),
                ),
                Text(
                  _formatDate(selectedDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => onDateChange(
                    selectedDate.add(const Duration(days: 1)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: meals.isEmpty
                ? const Center(child: Text('Записей пока нет'))
                : MealListView(
                    meals: meals,
                    onEdit: onEdit,
                    onDelete: (meal) => onDelete(meal.id),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Всего калорий: ${totalCalories.toStringAsFixed(0)}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Сегодня';
    }
    return '${date.day}.${date.month}.${date.year}';
  }
}
