import 'package:flutter/material.dart';
import 'dart:math';


class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {

  void _spin() {
    setState(() {
      _slot1 = _symbols[_random.nextInt(_symbols.length)];
      _slot2 = _symbols[_random.nextInt(_symbols.length)];
      _slot3 = _symbols[_random.nextInt(_symbols.length)];

      if (_slot1 == _slot2 && _slot2 == _slot3) {
        _coins += 3;
        _message = 'Победа! 🎉 +3 монеты';
      } else {
        _coins -= 1;
        _message = 'Попробуй ещё раз 😔 -1 монета';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '💰 Монеты: $_coins',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_slot1, width: 100, height: 100),
            SizedBox(width: 16),
            Image.asset(_slot2, width: 100, height: 100),
            SizedBox(width: 16),
            Image.asset(_slot3, width: 100, height: 100)
          ],
        ),
        SizedBox(height: 24),
        Text(
          _message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: _spin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ), 
          child: Text(
            'КРУТИТЬ 🎰',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  final _random = Random();

  final _symbols = [
    'assets/images/cherry.png',
    'assets/images/lemon.png',
    'assets/images/seven.png',
  ];

  var _coins = 10;
  var _slot1 = 'assets/images/cherry.png';
  var _slot2 = 'assets/images/lemon.png';
  var _slot3 = 'assets/images/seven.png';
  var _message = '';


}
