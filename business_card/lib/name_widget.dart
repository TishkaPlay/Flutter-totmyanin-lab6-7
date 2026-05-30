import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String name;
  
  const NameWidget({
    super.key, 
    required this.name
  });

  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black26,
              offset: Offset(2, 2),
            ),
          ],
        ),
        textAlign: 
        TextAlign.center,
      ),
    );
  }
}