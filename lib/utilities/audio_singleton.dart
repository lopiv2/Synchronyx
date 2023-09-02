import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  late AudioPlayer _audioPlayer;

  final ValueNotifier<String> currentUrlNotifier = ValueNotifier<String>('');
  final ValueNotifier<double> currentTrackPosition = ValueNotifier<double>(0);
  final ValueNotifier<double> totalTrackLength = ValueNotifier<double>(0);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    _audioPlayer = AudioPlayer();
  }

  get audioPlayer => _audioPlayer;

  Future<void> play(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  void setTotalTrackLength(double length) {
    totalTrackLength.value = length;
  }
}
