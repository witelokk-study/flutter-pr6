import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealTile extends StatelessWidget {
  final Meal meal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MealTile({
    super.key,
    required this.meal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeString =
        '${meal.time.hour.toString().padLeft(2, '0')}:${meal.time.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          meal.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${meal.category} • $timeString'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (meal.calories != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '${meal.calories!.toStringAsFixed(0)} ккал',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
