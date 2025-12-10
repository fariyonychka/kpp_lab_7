import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sleep_record.dart';
import '../models/food_record.dart';
import '../models/mood_record.dart';
import '../models/user_profile.dart';

class HealthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _sleepCollection {
    if (_userId == null) throw Exception('User not logged in');
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('sleep_records');
  }

  Stream<List<SleepRecord>> getSleepRecords() {
    return _sleepCollection.orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return SleepRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addSleepRecord(SleepRecord record) async {
    await _sleepCollection.add(record.toMap());
  }

  Future<void> updateSleepRecord(SleepRecord record) async {
    await _sleepCollection.doc(record.id).update(record.toMap());
  }

  Future<void> deleteSleepRecord(String id) async {
    await _sleepCollection.doc(id).delete();
  }

  CollectionReference get _foodCollection {
    if (_userId == null) throw Exception('User not logged in');
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('food_records');
  }

  Stream<List<FoodRecord>> getFoodRecords() {
    return _foodCollection.orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return FoodRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addFoodRecord(FoodRecord record) async {
    await _foodCollection.add(record.toMap());
  }

  Future<void> updateFoodRecord(FoodRecord record) async {
    await _foodCollection.doc(record.id).update(record.toMap());
  }

  Future<void> deleteFoodRecord(String id) async {
    try {
      final docSnapshot = await _foodCollection.doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;
        final photoUrls = List<String>.from(data?['photoUrls'] ?? []);

        for (final url in photoUrls) {
          try {
            final ref = _storage.refFromURL(url);
            await ref.delete();
          } catch (e) {
            // Ignore errors for individual photo deletions
          }
        }
      }

      // Delete the Firestore document
      await _foodCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadFoodPhoto(XFile imageFile, Uint8List imageBytes) async {
    if (_userId == null) return null;
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}.jpg';
      final Reference ref = _storage.ref().child(
        'food_photos/$_userId/$fileName',
      );

      final UploadTask uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  CollectionReference get _moodCollection {
    if (_userId == null) throw Exception('User not logged in');
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('mood_records');
  }

  Stream<List<MoodRecord>> getMoodRecords() {
    return _moodCollection.orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return MoodRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addMoodRecord(MoodRecord record) async {
    await _moodCollection.add(record.toMap());
  }

  Future<void> updateMoodRecord(MoodRecord record) async {
    await _moodCollection.doc(record.id).update(record.toMap());
  }

  Future<void> deleteMoodRecord(String id) async {
    await _moodCollection.doc(id).delete();
  }

  Future<void> ensureUserProfileExists({
    required String name,
    required String email,
    int? age,
    String? gender,
  }) async {
    if (_userId == null) return;

    final docRef = _firestore.collection('users').doc(_userId);
    final doc = await docRef.get();

    if (!doc.exists) {
      final profile = UserProfile(
        id: _userId!,
        name: name,
        email: email,
        age: age,
        gender: gender,
        createdAt: DateTime.now(),
      );
      await docRef.set(profile.toMap());
    }
  }

  Stream<UserProfile?> getUserProfileStream() {
    if (_userId == null) return Stream.value(null);
    return _firestore.collection('users').doc(_userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    if (_userId == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(_userId).update(profile.toMap());

    if (_auth.currentUser?.displayName != profile.name) {
      await _auth.currentUser?.updateDisplayName(profile.name);
    }
  }
}
