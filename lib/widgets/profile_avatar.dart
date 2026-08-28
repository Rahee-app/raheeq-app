import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileAvatar extends StatelessWidget {
  final Gender gender;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.gender,
    this.radius = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (gender) {
      case Gender.male:
        bgColor = const Color(0xFF3B82F6); // Serene Blue
        break;
      case Gender.female:
        bgColor = const Color(0xFFEC4899); // Serene Pink
        break;
      case Gender.unspecified:
        bgColor = const Color(0xFF16652B); // Raheeq Green
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: radius * 1.15,
        ),
      ),
    );
  }
}
