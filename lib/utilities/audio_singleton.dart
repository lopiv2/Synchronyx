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

  Future<void> playUrl(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> playFile(String source) async {
    await _audioPlayer.stop();
    isPlayingNotifier.value=true;
    await _audioPlayer.play(DeviceFileSource(source));
  }

  Future<void> pause() async {
    isPlayingNotifier.value = false;
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    isPlayingNotifier.value = false;
    await _audioPlayer.stop();
  }

  Future<void> resume() async {
    isPlayingNotifier.value = true;
    await _audioPlayer.resume();
  }

  void setTotalTrackLength(double length) {
    totalTrackLength.value = length;
  }
}
