import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:uuid/uuid.dart';

class MealFormScreen extends StatefulWidget {
  final Meal? meal;
  final DateTime? initialDate;

  const MealFormScreen({
    super.key,
    this.meal,
    this.initialDate,
  });

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late String _name;
  late String _category;
  late DateTime _date;
  late TimeOfDay _time;
  double? _calories;

  final _categories = ['Завтрак', 'Обед', 'Ужин', 'Перекус'];

  @override
  void initState() {
    super.initState();
    final meal = widget.meal;
    _name = meal?.name ?? '';
    _category = meal?.category ?? 'Завтрак';
    _date = meal?.date ?? widget.initialDate ?? DateTime.now();
    _time = meal != null
        ? TimeOfDay.fromDateTime(meal.time)
        : TimeOfDay.now();
    _calories = meal?.calories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Добавить приём пищи' : 'Редактировать'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Название блюда'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _category,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _category = value!;
                }),
                decoration: const InputDecoration(labelText: 'Категория'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _calories?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Калорийность (ккал)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _calories = double.tryParse(value);
                  }
                },
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата: ${_date.day}.${_date.month}.${_date.year}'),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Изменить'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Время: ${_time.format(context)}'),
                  TextButton(
                    onPressed: _pickTime,
                    child: const Text('Изменить'),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveMeal,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _saveMeal() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final meal = Meal(
        id: widget.meal?.id ?? _uuid.v4(),
        name: _name,
        category: _category,
        date: _date,
        time: DateTime(
          _date.year,
          _date.month,
          _date.day,
          _time.hour,
          _time.minute,
        ),
        calories: _calories,
      );

      Navigator.pop(context, meal);
    }
  }
}
