import 'package:cloud_firestore/cloud_firestore.dart';

class SleepRecord {
  final String id;
  final DateTime date;
  final double durationHours;
  final String quality;
  final String? notes;
  final DateTime createdAt;

  SleepRecord({
    required this.id,
    required this.date,
    required this.durationHours,
    required this.quality,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'durationHours': durationHours,
      'quality': quality,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory SleepRecord.fromMap(Map<String, dynamic> map, String id) {
    return SleepRecord(
      id: id,
      date: (map['date'] as Timestamp).toDate(),
      durationHours: (map['durationHours'] as num).toDouble(),
      quality: map['quality'] ?? '',
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  SleepRecord copyWith({
    String? id,
    DateTime? date,
    double? durationHours,
    String? quality,
    String? notes,
    DateTime? createdAt,
  }) {
    return SleepRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      durationHours: durationHours ?? this.durationHours,
      quality: quality ?? this.quality,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
