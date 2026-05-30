import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'slot_row.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {

  final Random _random = Random();
  
  final List<String> _symbols = [
    'assets/images/cherry.png',
    'assets/images/lemon.png',
    'assets/images/seven.png',
  ];

  int _coins = 10;
  String _slot1 = 'assets/images/cherry.png';
  String _slot2 = 'assets/images/cherry.png';
  String _slot3 = 'assets/images/cherry.png';
  String _message = 'Удачи! 🎰';
  bool _isSpinning = false;

  Future<void> _spinReel(int totalTicks, void Function(String) onTick) async {
    for (int i = 0; i < totalTicks; i++) {
      final progress = i / totalTicks;
      final delay = progress < 0.5
          ? const Duration(milliseconds: 40)
          : progress < 0.8
              ? const Duration(milliseconds: 100)
              : const Duration(milliseconds: 200);
      
      final randomSymbol = _symbols[_random.nextInt(_symbols.length)];
      onTick(randomSymbol);
      
      await Future.delayed(delay);
    }
  }

  Future<void> _spin() async {
    if (_coins <= 0 || _isSpinning) {
      if (_coins <= 0) {
        setState(() {
          _message = 'Монеты закончились 😢';
        });
      }
      return;
    }

    setState(() {
      _isSpinning = true;
      _message = 'Крутим...';
    });

    _coins -= 1;

    await _spinReel(10, (symbol) => setState(() => _slot1 = symbol));
    await _spinReel(13, (symbol) => setState(() => _slot2 = symbol));
    await _spinReel(16, (symbol) => setState(() => _slot3 = symbol));

    setState(() {
      _isSpinning = false;
      
      if (_slot1 == _slot2 && _slot2 == _slot3) {
        if (_slot1 == 'assets/images/seven.png') {
          _coins += 10;
          _message = 'ДЖЕКПОТ! 🎉 +10 монет';
        } else {
          _coins += 3;
          _message = 'Победа! 🎉 +3 монеты';
        }
      } else {
        _message = 'Попробуй ещё раз 😔';
      }
    });
  }

  void _reset() {
    setState(() {
      _coins = 10;
      _message = 'Удачи! 🎰';
      _slot1 = 'assets/images/cherry.png';
      _slot2 = 'assets/images/cherry.png';
      _slot3 = 'assets/images/cherry.png';
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text('Слот-машина'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Счётчик монет
              Text(
                '💰 Монеты: $_coins',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 50),

              AnimatedOpacity(
                opacity: _isSpinning ? 0.85 : 1.0,
                duration: Duration(milliseconds: 100),
                child: SlotRow(
                  symbol1: _slot1,
                  symbol2: _slot2,
                  symbol3: _slot3,
                ),
              ),

              const SizedBox(height: 30),

              // Сообщение с анимацией
              SizedBox(
                height: 40,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _message,
                    key: ValueKey<String>(_message),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: (_coins > 0 && !_isSpinning) 
                    ? _spin 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  _isSpinning ? 'Крутим...' : 'КРУТИТЬ 🎰',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Кнопка СБРОС (блокируется во время вращения)
              TextButton(
                onPressed: !_isSpinning ? _reset : null,
                child: const Text(
                  'Начать заново',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}