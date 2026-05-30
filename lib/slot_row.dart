import 'package:flutter/material.dart';

class SlotRow extends StatelessWidget {
  final String symbol1;
  final String symbol2;
  final String symbol3;

  const SlotRow({
    super.key,
    required this.symbol1,
    required this.symbol2,
    required this.symbol3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white54, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSlot(symbol1),
          _buildSlot(symbol2),
          _buildSlot(symbol3),
        ],
      ),
    );
  }

  Widget _buildSlot(String imagePath) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(imagePath, fit: BoxFit.contain),
    );
  }
}