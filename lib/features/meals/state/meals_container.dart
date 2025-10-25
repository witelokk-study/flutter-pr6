import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meals_list_screen.dart';
import '../screens/meal_form_screen.dart';
import '../screens/statistics_screen.dart';

enum Screen { list, form, stats }

class MealsContainer extends StatefulWidget {
  const MealsContainer({super.key});

  @override
  State<MealsContainer> createState() => _MealsContainerState();
}

class _MealsContainerState extends State<MealsContainer> {
  final List<Meal> _meals = [];
  Screen _currentScreen = Screen.list;
  DateTime _selectedDate = DateTime.now();
  Meal? _editingMeal;

  List<Meal> _getMealsForDate(DateTime date) {
    return _meals.where((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day).toList();
  }

  void _showList() => setState(() {
        _currentScreen = Screen.list;
        _editingMeal = null;
      });

  void _showForm({Meal? meal, DateTime? date}) => setState(() {
        _currentScreen = Screen.form;
        _editingMeal = meal;
        if (date != null) _selectedDate = date;
      });

  void _showStats() => setState(() {
        _currentScreen = Screen.stats;
      });

  void _addMeal(Meal meal) {
    setState(() {
      _meals.add(meal);
      _currentScreen = Screen.list;
    });
  }

  void _updateMeal(Meal updated) {
    setState(() {
      final index = _meals.indexWhere((m) => m.id == updated.id);
      if (index != -1) _meals[index] = updated;
      _currentScreen = Screen.list;
    });
  }

  void _deleteMeal(String id) {
    setState(() {
      _meals.removeWhere((m) => m.id == id);
    });
  }

  int get _currentIndex {
    switch (_currentScreen) {
      case Screen.list:
        return 0;
      case Screen.stats:
        return 1;
      default:
        return 0;
    }
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      _showList();
    } else if (index == 1) {
      _showStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_currentScreen) {
      case Screen.list:
        body = MealsListScreen(
          meals: _getMealsForDate(_selectedDate),
          selectedDate: _selectedDate,
          onDateChange: (newDate) => setState(() => _selectedDate = newDate),
          onAdd: () => _showForm(date: _selectedDate),
          onEdit: (meal) => _showForm(meal: meal),
          onDelete: _deleteMeal,
        );
        break;

      case Screen.form:
        body = MealFormScreen(
          meal: _editingMeal,
          initialDate: _selectedDate,
          onSave: (meal) {
            if (_editingMeal == null) {
              _addMeal(meal);
            } else {
              _updateMeal(meal);
            }
          },
          onCancel: _showList,
        );
        break;

      case Screen.stats:
        body = StatisticsScreen(meals: _meals);
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: _currentScreen == Screen.form
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Дневник',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Статистика',
                ),
              ],
            ),
    );
  }
}