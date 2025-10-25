class Meal {
  final String id;
  String name;
  String category; 
  DateTime date;
  DateTime time;
  double? quantity; 
  double? calories;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.time,
    this.quantity,
    this.calories,
  });
}

