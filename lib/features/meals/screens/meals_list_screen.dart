import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../state/meals_container.dart';
import '../widgets/meal_list_view.dart';
import 'meal_form_screen.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen({super.key});

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final mealsContainer = MealsContainer.of(context);

    final mealsForDay = mealsContainer.getMealsForDate(selectedDate);
    final totalCalories = mealsForDay.fold<double>(
      0,
      (sum, meal) => sum + (meal.calories ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник питания'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Отображение выбранной даты
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                ),
                Text(
                  _formatDate(selectedDate),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
          ),

          // Список приёмов пищи
          Expanded(
            child: mealsForDay.isEmpty
                ? const Center(child: Text('Записей пока нет'))
                : MealListView(
                    meals: mealsForDay,
                    onDelete: (meal) {
                      setState(() {
                        mealsContainer.deleteMeal(meal.id);
                      });
                    },
                    onEdit: (meal) async {
                      final updatedMeal = await Navigator.push<Meal>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealFormScreen(meal: meal),
                        ),
                      );
                      if (updatedMeal != null) {
                        setState(() {
                          mealsContainer.updateMeal(updatedMeal);
                        });
                      }
                    },
                  ),
          ),

          // Сводка по калорийности
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Всего калорий: ${totalCalories.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),

      // Кнопка добавления
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMeal = await Navigator.push<Meal>(
            context,
            MaterialPageRoute(
              builder: (context) => MealFormScreen(
                initialDate: selectedDate,
              ),
            ),
          );
          if (newMeal != null) {
            setState(() {
              mealsContainer.addMeal(newMeal);
            });
          }
        },
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
