import 'package:cloud_firestore/cloud_firestore.dart';

class FoodRecord {
  final String id;
  final DateTime date;
  final String dishName;
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  final String? notes;
  final List<String> photoUrls;
  final DateTime createdAt;

  FoodRecord({
    required this.id,
    required this.date,
    required this.dishName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.notes,
    this.photoUrls = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'dishName': dishName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'notes': notes,
      'photoUrls': photoUrls,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FoodRecord.fromMap(Map<String, dynamic> map, String id) {
    return FoodRecord(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      dishName: map['dishName'] ?? '',
      calories: map['calories'] ?? 0,
      protein: (map['protein'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      notes: map['notes'],
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  FoodRecord copyWith({
    String? id,
    DateTime? date,
    String? dishName,
    int? calories,
    double? protein,
    double? fat,
    double? carbs,
    String? notes,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return FoodRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      dishName: dishName ?? this.dishName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
