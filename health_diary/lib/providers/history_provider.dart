import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../repositories/health_repository.dart';
import '../models/sleep_record.dart';
import '../models/food_record.dart';
import '../models/mood_record.dart';
import '../models/health_record.dart';

enum HistoryStatus { loading, loaded, error }

class HistoryProvider with ChangeNotifier {
  final HealthRepository _repository = HealthRepository();
  StreamSubscription? _subscription;

  HistoryStatus _status = HistoryStatus.loading;
  List<HealthRecord> _records = [];
  RecordType? _filterType;
  bool _sortAscending = false;

  HistoryStatus get status => _status;
  List<HealthRecord> get records => _records;
  RecordType? get filterType => _filterType;
  bool get sortAscending => _sortAscending;

  HistoryProvider() {
    loadRecords();
  }

  List<HealthRecord> get filteredRecords {
    var filtered = _records;
    if (_filterType != null) {
      filtered = filtered.where((r) => r.type == _filterType!).toList();
    }
    filtered = List.from(filtered)
      ..sort(
        (a, b) => _sortAscending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date),
      );
    return filtered;
  }

  void loadRecords() {
    _status = HistoryStatus.loading;
    notifyListeners();

    try {
      final sleepStream = _repository.getSleepRecords();
      final foodStream = _repository.getFoodRecords();
      final moodStream = _repository.getMoodRecords();

      _subscription?.cancel();
      _subscription =
          Rx.combineLatest3(sleepStream, foodStream, moodStream, (
            List<SleepRecord> sleep,
            List<FoodRecord> food,
            List<MoodRecord> mood,
          ) {
            final List<HealthRecord> allRecords = [];

            for (var s in sleep) {
              allRecords.add(
                HealthRecord(
                  id: s.id,
                  date: s.date,
                  type: RecordType.sleep,
                  title: 'Сон',
                  subtitle: '${s.durationHours} годин · ${s.quality}',
                  details: {
                    'duration': s.durationHours.toString(),
                    'quality': s.quality,
                    'notes': s.notes ?? '',
                    'createdAt': s.createdAt,
                  },
                ),
              );
            }

            for (var f in food) {
              allRecords.add(
                HealthRecord(
                  id: f.id,
                  date: f.date,
                  type: RecordType.food,
                  title: f.dishName,
                  subtitle: '${f.calories} ккал · Білки: ${f.protein}г',
                  details: {
                    'calories': f.calories,
                    'protein': f.protein,
                    'fat': f.fat,
                    'carbs': f.carbs,
                    'notes': f.notes ?? '',
                    'photoUrls': f.photoUrls,
                    'createdAt': f.createdAt,
                  },
                ),
              );
            }

            for (var m in mood) {
              allRecords.add(
                HealthRecord(
                  id: m.id,
                  date: m.date,
                  type: RecordType.mood,
                  title: m.mood,
                  subtitle: 'Енергія: ${m.energyLevel}/10 · ${m.physicalState}',
                  details: {
                    'mood': m.mood,
                    'energy': '${m.energyLevel}/10',
                    'physical': m.physicalState,
                    'notes': m.notes ?? '',
                    'createdAt': m.createdAt,
                  },
                ),
              );
            }

            allRecords.sort((a, b) => b.date.compareTo(a.date));
            return allRecords;
          }).listen(
            (records) {
              _records = records;
              _status = HistoryStatus.loaded;
              notifyListeners();
            },
            onError: (error) {
              _status = HistoryStatus.error;
              notifyListeners();
            },
          );
    } catch (e) {
      _status = HistoryStatus.error;
      notifyListeners();
    }
  }

  void setFilter(RecordType? type) {
    _filterType = type;
    notifyListeners();
  }

  void toggleSort() {
    _sortAscending = !_sortAscending;
    notifyListeners();
  }

  void clearFilter() {
    _filterType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
