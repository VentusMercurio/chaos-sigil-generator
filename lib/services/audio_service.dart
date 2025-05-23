// lib/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // For kReleaseMode

class AudioService {
  AudioService._privateConstructor();
  static final AudioService instance = AudioService._privateConstructor();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicActuallyPlaying = false; // More accurate name for player's state
  bool _shouldBePlaying = false; // User's intent / app's intent for music

  bool get isMusicPlaying =>
      _isMusicActuallyPlaying; // What the player is doing
  bool get shouldBePlayingIntent => _shouldBePlaying; // What we want it to do

  AudioService() {
    // Add a constructor to listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      _isMusicActuallyPlaying = (s == PlayerState.playing);
      if (!kReleaseMode) {
        print('AudioService: Current player state: $s');
      }
    });

    _audioPlayer.onLog.listen((String message) {
      // Listen to player logs
      if (!kReleaseMode) {
        print('AudioService Player Log: $message');
      }
    });
  }

  Future<void> initializeAndPlayMusic(
      {String assetPath = 'audio/background.mp3'}) async {
    if (!kReleaseMode) {
      print(
          "AudioService: Attempting to initialize and play music. Current _shouldBePlaying: $_shouldBePlaying, _isMusicActuallyPlaying: $_isMusicActuallyPlaying");
    }
    if (_shouldBePlaying && _isMusicActuallyPlaying) {
      if (!kReleaseMode)
        print("AudioService: Music is already initialized and playing.");
      return;
    }

    _shouldBePlaying = true; // Set intent to play

    try {
      // It's good practice to stop before setting a new source if it might already be loaded
      // await _audioPlayer.stop(); // Consider if this is needed or causes issues
      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer
          .resume(); // This should trigger onPlayerStateChanged to playing
      // _isMusicActuallyPlaying will be updated by the listener
      if (!kReleaseMode) {
        print("AudioService: Music initialization and play command sent.");
      }
    } catch (e) {
      _shouldBePlaying = false; // Failed, so intent is no longer to play
      _isMusicActuallyPlaying = false;
      if (!kReleaseMode) {
        print("AudioService: Error initializing/playing music - $e");
      }
    }
  }

  Future<void> playMusic() async {
    // This is more like "ensureMusicIsPlaying"
    if (!kReleaseMode) {
      print(
          "AudioService: Attempting to play/resume music. Current _shouldBePlaying: $_shouldBePlaying, _isMusicActuallyPlaying: $_isMusicActuallyPlaying");
    }
    if (!_shouldBePlaying) {
      // If there was no prior intent to play, initialize.
      await initializeAndPlayMusic();
      return;
    }

    if (_isMusicActuallyPlaying) {
      if (!kReleaseMode) print("AudioService: Music is already playing.");
      return; // Already playing
    }

    _shouldBePlaying = true; // Reinforce intent

    try {
      await _audioPlayer.resume();
      if (!kReleaseMode) {
        print("AudioService: Music resume command sent.");
      }
    } catch (e) {
      if (!kReleaseMode) {
        print("AudioService: Error resuming music - $e");
      }
    }
  }

  Future<void> pauseMusic() async {
    if (!kReleaseMode) {
      print(
          "AudioService: Attempting to pause music. Current _isMusicActuallyPlaying: $_isMusicActuallyPlaying");
    }
    if (!_isMusicActuallyPlaying) {
      if (!kReleaseMode)
        print("AudioService: Music is not playing, cannot pause.");
      return;
    }

    _shouldBePlaying = false; // User/app intent is to pause

    try {
      await _audioPlayer.pause();
      // _isMusicActuallyPlaying will be updated by the listener
      if (!kReleaseMode) {
        print("AudioService: Music pause command sent.");
      }
    } catch (e) {
      if (!kReleaseMode) {
        print("AudioService: Error pausing music - $e");
      }
    }
  }

  // stopMusic and disposePlayer can remain as they were, or add similar logging
  Future<void> stopMusic() async {
    _shouldBePlaying = false;
    if (_isMusicActuallyPlaying || _audioPlayer.state != PlayerState.stopped) {
      // Check if it needs stopping
      try {
        await _audioPlayer.stop();
        if (!kReleaseMode) print("AudioService: Music stop command sent.");
      } catch (e) {
        if (!kReleaseMode) print("AudioService: Error stopping music - $e");
      }
    } else {
      if (!kReleaseMode) print("AudioService: Music already stopped.");
    }
  }

  Future<void> disposePlayer() async {
    _shouldBePlaying = false;
    try {
      await _audioPlayer.dispose();
      if (!kReleaseMode) print("AudioService: Player disposed.");
    } catch (e) {
      if (!kReleaseMode) print("AudioService: Error disposing player - $e");
    }
    _isMusicActuallyPlaying = false;
  }
}
