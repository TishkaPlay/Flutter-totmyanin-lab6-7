import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  final String group;
  
  const GroupWidget({
    super.key, 
    required this.group
  });

  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 8
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: 
            Colors.white38, 
            width: 1.5
          ),
        ),
        child: Text(
          'Группа: $group',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}