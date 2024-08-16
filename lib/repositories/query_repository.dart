import 'package:dartz/dartz.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/failure/failure.dart';

class QueryRepository {
  final OnAudioQuery _audioQuery;

  QueryRepository({required OnAudioQuery audioQuery})
      : _audioQuery = audioQuery;

  List<SongModel> _allSongs = [];
  List<PlaylistModel> _allPlaylists = [];

  List<SongModel> get allSongs => _allSongs;
  List<PlaylistModel> get allPlaylists => _allPlaylists;

  Future<Either<Failure, List<SongModel>>> queryAllSongs() async {
    try {
      _allSongs = await _audioQuery.querySongs();
      return right(_allSongs);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<PlaylistModel>>> queryAllPlaylists() async {
    try {
      _allPlaylists =
          await _audioQuery.queryPlaylists();
      return right(_allPlaylists);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
