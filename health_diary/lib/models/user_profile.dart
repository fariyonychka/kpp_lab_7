import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final int? age;
  final String? gender;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.gender,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'],
      gender: map['gender'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? gender,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
