import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'slot_row.dart';
import 'sound_service.dart';

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
  bool _backgroundStarted = false;

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

    // Запуск фоновой музыки при первом нажатии
    if (!_backgroundStarted) {
      await SoundService.playBackground();
      setState(() {
        _backgroundStarted = true;
      });
    }

    // Звук нажатия кнопки
    await SoundService.playClick();

    setState(() {
      _isSpinning = true;
      _message = 'Крутим...';
    });

    _coins -= 1;

    await _spinReel(10, (symbol) => setState(() => _slot1 = symbol));
    await _spinReel(13, (symbol) => setState(() => _slot2 = symbol));
    await _spinReel(16, (symbol) => setState(() => _slot3 = symbol));

    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      _isSpinning = false;
      
      if (_slot1 == _slot2 && _slot2 == _slot3) {
        if (_slot1 == 'assets/images/seven.png') {
          _coins += 10;
          _message = 'ДЖЕКПОТ! 🎉 +10 монет';
          SoundService.playJackpot();
        } else {
          _coins += 3;
          _message = 'Победа! 🎉 +3 монеты';
          SoundService.playWin();
        }
      } else {
        _message = 'Попробуй ещё раз 😔';
        SoundService.playLose();
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

  bool _isMuted = SoundService.isMuted;

  Future<void> _toggleMute() async {
    await SoundService.toggleMute();
    setState(() {
      _isMuted = SoundService.isMuted;
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
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: _toggleMute,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                opacity: _isSpinning ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: SlotRow(
                  symbol1: _slot1,
                  symbol2: _slot2,
                  symbol3: _slot3,
                ),
              ),

              const SizedBox(height: 30),

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
                onPressed: (_coins > 0 && !_isSpinning) ? _spin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_coins > 0 && !_isSpinning)
                      ? Colors.deepPurple
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: Text(
                  _isSpinning ? 'КРУТИТСЯ...' : 'КРУТИТЬ 🎰',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 15),

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