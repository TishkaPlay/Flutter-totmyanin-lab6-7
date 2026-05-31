import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static AudioPlayer? _backgroundPlayer;
  static bool _backgroundStarted = false;
  static bool _isMuted = false;
  
  //пул плееров для звуковых эффектов
  static final List<AudioPlayer> _sfxPool = [];
  static int _sfxIndex = 0;
  static const int _poolSize = 4;

  static bool get isMuted => _isMuted;

  static Future<void> init() async {
    //инициализируем пул плееров заранее
    for (int i = 0; i < _poolSize; i++) {
      final p = AudioPlayer();
      await p.setPlayerMode(
        PlayerMode.lowLatency
      ); //быстрый режим для эффектов
      _sfxPool.add(p);
    }
  }

  static Future<void> playBackground() async {
    if (_backgroundStarted) return; //не запускать повторно
    _backgroundStarted = true;

    _backgroundPlayer = AudioPlayer();
    await _backgroundPlayer!.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer!.setVolume(_isMuted ? 0.0 : 0.4);
    await _backgroundPlayer!.play(AssetSource('sounds/background.mp3'));
  }

  static Future<void> _playSound(String fileName, {double volume = 1.0}) async {
    if (_isMuted) return;

    //берём плеер из пула по кругу
    final player = _sfxPool[_sfxIndex % _poolSize];
    _sfxIndex++;
    
    await player.stop();
    await player.setVolume(volume);
    await player.play(AssetSource('sounds/$fileName'));
  }

  static Future<void> playWin() => _playSound('win.mp3');
  static Future<void> playJackpot() => _playSound('jackpot.mp3');
  static Future<void> playLose() => _playSound('lose.mp3', volume: 0.7);
  static Future<void> playClick() => _playSound('click.mp3', volume: 0.6);

  static Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _backgroundPlayer?.setVolume(0.0);
    } else {
      await _backgroundPlayer?.setVolume(0.4);
    }
  }

  static Future<void> dispose() async {
    await _backgroundPlayer?.dispose();
    for (final p in _sfxPool) {
      await p.dispose();
    }
    _sfxPool.clear();
    _backgroundStarted = false;
  }
}