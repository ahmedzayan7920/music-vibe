import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_vibe/extensions/extensions.dart';
import 'package:music_vibe/handlers/dependency_injection.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init<MyAudioHandler>(
      builder: () => MyAudioHandler(),
      config:  AudioServiceConfig(
        androidNotificationChannelId: 'com.example.music_vibe.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidShowNotificationBadge: true,
        androidStopForegroundOnPause: true,
        androidNotificationOngoing: true,
        androidResumeOnClick: true,
        notificationColor: Colors.grey[900],
        androidNotificationIcon: "drawable/ic_stat_music_note",
      ));
}

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  MyAudioHandler() {
    // Map the playback event stream to the playback state
    _audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // Listen to the sequenceStateStream and update the notification
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState != null && sequenceState.currentSource != null) {
        final mediaItem = _convertToMediaItem(sequenceState.currentSource!);
        _updateNotification(mediaItem);
      }
    });

    // Listen to the playerStateStream and save the audio state
    _audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.idle ||
          event.playing == false) {
        saveAudioState();
      }
    });
  }

  @override
  Future<void> onTaskRemoved() {
    // TODO: implement onTaskRemoved
    return super.onTaskRemoved();
  }

  Future<void> restoreAudioState() async {
    int currentPosition =
        getIt<SharedPreferences>().getInt('audio_position') ?? 0;
    int currentIndex = getIt<SharedPreferences>().getInt('current_index') ?? 0;
    bool shuffle = getIt<SharedPreferences>().getBool('shuffle') ?? false;
    String loop = getIt<SharedPreferences>().getString('loop') ?? "";
    String? savedSources = getIt<SharedPreferences>().getString('audio_source');

    if (savedSources != null) {
      List<dynamic> sourceList = jsonDecode(savedSources);
      List<UriAudioSource> sources = sourceList.map((source) {
        final sourceMap = source as Map<String, dynamic>;
        return AudioSource.uri(
          Uri.parse(sourceMap['uri'] as String),
          tag: (sourceMap['tag'] as Map<String, dynamic>).fromJson(),
        );
      }).toList();

      _audioPlayer.setShuffleModeEnabled(shuffle);
      _audioPlayer.setLoopMode(loop.toLoopMode());
      _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: currentIndex,
        initialPosition: Duration(milliseconds: currentPosition),
      );
    }
  }

  void saveAudioState() {
    final audioSource = _audioPlayer.audioSource;
    if (audioSource != null && audioSource is ConcatenatingAudioSource) {
      List<Map<String, dynamic>> sources = [];
      for (var source in audioSource.children) {
        if (source is UriAudioSource) {
          sources.add({
            'uri': source.uri.toString(),
            'tag': (source.tag as MediaItem).toJson(),
          });
        }
      }
      getIt<SharedPreferences>().setString('audio_source', jsonEncode(sources));
    }
    getIt<SharedPreferences>()
        .setInt('audio_position', _audioPlayer.position.inMilliseconds);
    getIt<SharedPreferences>()
        .setInt('current_index', _audioPlayer.currentIndex ?? 0);
    getIt<SharedPreferences>()
        .setBool('shuffle', _audioPlayer.shuffleModeEnabled);
    getIt<SharedPreferences>()
        .setString('loop', _audioPlayer.loopMode.toShortString());
  }

  Future<void> setupPlaylist(List<SongModel> playlist, int startIndex) async {
    final sources = playlist.map((song) {
      return AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          album: song.album ?? 'Unknown Album',
          title: song.title,
          artist: song.artist ?? 'Unknown Artist',
          duration: Duration(milliseconds: song.duration ?? 0),
          artUri: Uri.parse(song.uri!),
        ),
      );
    }).toList();

    final playlistSource = ConcatenatingAudioSource(children: sources);

    if (playlist.isNotEmpty) {
      await _audioPlayer.setAudioSource(playlistSource,
          initialIndex: startIndex);
      play();
    }
  }

  MediaItem _convertToMediaItem(IndexedAudioSource source) {
    return source.tag as MediaItem;
  }

  void _updateNotification(MediaItem item) {
    mediaItem.add(item);
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> skipToNext() =>
      _audioPlayer.seekToNext().then((_) => _audioPlayer.play());

  @override
  Future<void> skipToPrevious() =>
      _audioPlayer.seekToPrevious().then((_) => _audioPlayer.play());

  @override
  Future<void> seek(Duration position, {int? index}) => _audioPlayer
      .seek(position, index: index)
      .then((_) => _audioPlayer.play());

  @override
  Future<void> stop() => _audioPlayer.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_audioPlayer.processingState]!,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
    );
  }

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    if (button != MediaButton.media) {
      return super.click(button);
    } else {
      _handleClick();
    }
  }

  Timer? _clickTimer;
  int _clickCount = 0;

  void _handleClick() {
    _clickCount++;

    _clickTimer?.cancel();
    _clickTimer = Timer(const Duration(milliseconds: 300), () {
      if (_clickCount == 1) {
        // Single click: Play/Pause
        if (_audioPlayer.playing) {
          pause();
        } else {
          play();
        }
      } else if (_clickCount == 2) {
        // Double click: Next track
        skipToNext();
      } else if (_clickCount == 3) {
        // Triple click: Previous track
        skipToPrevious();
      }
      _clickCount = 0;
    });
  }
}
