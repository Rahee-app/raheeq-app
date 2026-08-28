import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum Gender {
  male,
  female,
  unspecified,
}

class UserProfile {
  final String id;
  String name;
  final String email;
  Gender gender;
  final String? photoUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.gender = Gender.unspecified,
    this.photoUrl,
  });

  Color get avatarColor {
    switch (gender) {
      case Gender.female:
        return AppColors.femaleAvatar;
      case Gender.male:
        return AppColors.maleAvatar;
      case Gender.unspecified:
        return AppColors.primaryGreen;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender.name,
      'photoUrl': photoUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: Gender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => Gender.unspecified,
      ),
      photoUrl: json['photoUrl'] as String?,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    Gender? gender,
    String? photoUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
