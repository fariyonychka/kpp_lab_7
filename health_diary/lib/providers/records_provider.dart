import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sleep_record.dart';
import '../models/food_record.dart';
import '../models/mood_record.dart';
import '../repositories/health_repository.dart';

class RecordsProvider with ChangeNotifier {
  final HealthRepository _repository = HealthRepository();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> addSleepRecord(SleepRecord record) async {
    _setLoading(true);
    try {
      await _repository.addSleepRecord(record);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateSleepRecord(SleepRecord record) async {
    _setLoading(true);
    try {
      await _repository.updateSleepRecord(record);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> addFoodRecord(
    FoodRecord record,
    List<XFile> newImages,
    List<Uint8List> newImageBytes,
  ) async {
    _setLoading(true);
    try {
      final List<String> photoUrls = List.from(record.photoUrls);

      for (int i = 0; i < newImages.length; i++) {
        final url = await _repository.uploadFoodPhoto(
          newImages[i],
          newImageBytes[i],
        );
        if (url != null) {
          photoUrls.add(url);
        }
      }

      final recordWithPhotos = record.copyWith(photoUrls: photoUrls);
      await _repository.addFoodRecord(recordWithPhotos);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateFoodRecord(
    FoodRecord record,
    List<XFile> newImages,
    List<Uint8List> newImageBytes,
  ) async {
    _setLoading(true);
    try {
      final List<String> photoUrls = List.from(record.photoUrls);

      for (int i = 0; i < newImages.length; i++) {
        final url = await _repository.uploadFoodPhoto(
          newImages[i],
          newImageBytes[i],
        );
        if (url != null) {
          photoUrls.add(url);
        }
      }

      final recordWithPhotos = record.copyWith(photoUrls: photoUrls);
      await _repository.updateFoodRecord(recordWithPhotos);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> addMoodRecord(MoodRecord record) async {
    _setLoading(true);
    try {
      await _repository.addMoodRecord(record);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateMoodRecord(MoodRecord record) async {
    _setLoading(true);
    try {
      await _repository.updateMoodRecord(record);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteMoodRecord(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteMoodRecord(id);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteSleepRecord(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteSleepRecord(id);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteFoodRecord(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteFoodRecord(id);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _error = null;
    notifyListeners();
  }

  void _setError(String value) {
    _isLoading = false;
    _error = value;
    notifyListeners();
  }
}
