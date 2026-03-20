import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';

class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onDark.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.surfaceAccent)),
        ],
      ),
    );
  }
}
