import 'package:cloud_firestore/cloud_firestore.dart';

class MoodRecord {
  final String id;
  final DateTime date;
  final String mood;
  final int energyLevel;
  final String physicalState;
  final String? notes;
  final DateTime createdAt;

  MoodRecord({
    required this.id,
    required this.date,
    required this.mood,
    required this.energyLevel,
    required this.physicalState,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'mood': mood,
      'energyLevel': energyLevel,
      'physicalState': physicalState,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MoodRecord.fromMap(Map<String, dynamic> map, String id) {
    return MoodRecord(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      mood: map['mood'] ?? '',
      energyLevel: map['energyLevel'] ?? 0,
      physicalState: map['physicalState'] ?? '',
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  MoodRecord copyWith({
    String? id,
    DateTime? date,
    String? mood,
    int? energyLevel,
    String? physicalState,
    String? notes,
    DateTime? createdAt,
  }) {
    return MoodRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      physicalState: physicalState ?? this.physicalState,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
