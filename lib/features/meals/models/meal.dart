class Meal {
  final String id;
  String name;
  String category; // "Завтрак", "Обед", "Ужин", "Перекус"
  DateTime date;
  DateTime time;
  double? quantity; // по желанию, в граммах
  double? calories; // по желанию, калории

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