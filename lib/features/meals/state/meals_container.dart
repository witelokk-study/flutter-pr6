import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealsContainer extends InheritedWidget {
  final List<Meal> _meals = [];

  MealsContainer({super.key, required super.child});

  static MealsContainer of(BuildContext context) {
    final MealsContainer? result =
        context.dependOnInheritedWidgetOfExactType<MealsContainer>();
    assert(result != null, 'MealsContainer not found in context');
    return result!;
  }

  List<Meal> get meals => _meals;

  void addMeal(Meal meal) {
    _meals.add(meal);
  }

  void updateMeal(Meal updated) {
    final index = _meals.indexWhere((m) => m.id == updated.id);
    if (index != -1) _meals[index] = updated;
  }

  void deleteMeal(String id) {
    _meals.removeWhere((m) => m.id == id);
  }

  List<Meal> getMealsForDate(DateTime date) {
    return _meals.where((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day).toList();
  }

  @override
  bool updateShouldNotify(MealsContainer oldWidget) =>
      oldWidget._meals != _meals;
}
