import 'package:flutter/material.dart';
import 'features/meals/state/meals_container.dart';
import 'features/meals/screens/meals_list_screen.dart';

void main() {
  runApp(const FoodDiaryApp());
}

class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MealsContainer(
      child: MaterialApp(
        title: 'Дневник питания',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        home: const MealsListScreen(),
      ),
    );
  }
}
