import 'package:flutter/material.dart';

class LanguageWidget extends StatelessWidget {
  final String language;
  
  const LanguageWidget({
    super.key, 
    required this.language
  });

  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.code,
            color: Colors.amber,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Любимый язык: $language',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}