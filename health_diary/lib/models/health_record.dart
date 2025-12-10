import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum RecordType { sleep, food, mood }

class HealthRecord {
  final String id;
  final DateTime date;
  final RecordType type;
  final String title;
  final String subtitle;
  final Map<String, dynamic> details;

  HealthRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  IconData get iconData {
    switch (type) {
      case RecordType.sleep:
        return Icons.bed;
      case RecordType.food:
        return Icons.food_bank_rounded;
      case RecordType.mood:
        return Icons.mood;
    }
  }

  Color get color {
    switch (type) {
      case RecordType.sleep:
        return AppColors.iconSleep;
      case RecordType.food:
        return AppColors.iconFood;
      case RecordType.mood:
        return AppColors.iconMood;
    }
  }
}
