import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'meal_tile.dart';

class MealListView extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal meal) onEdit;
  final void Function(Meal meal) onDelete;

  const MealListView({
    super.key,
    required this.meals,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const Center(child: Text('Нет записей за этот день'));
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return MealTile(
          meal: meal,
          onEdit: () => onEdit(meal),
          onDelete: () => onDelete(meal),
        );
      },
    );
  }
}
