import 'package:dartz/dartz.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/failure/failure.dart';

class QueryRepository {
  final OnAudioQuery _audioQuery;
  List<SongModel> _allSongs = [];

  QueryRepository({required OnAudioQuery audioQuery})
      : _audioQuery = audioQuery;

  Future<Either<Failure, List<SongModel>>> queryAllSongs() async {
    print("queryAllSongs Started");
    try {
      _allSongs = await _audioQuery.querySongs();
      print("queryAllSongs Ended with ${_allSongs.length} songs");
      return right(_allSongs);
    } catch (error) {
      print("queryAllSongs Error: $error");
      return left(Failure(message: error.toString()));
    }
  }

  List<SongModel> get allSongs => _allSongs;
}
