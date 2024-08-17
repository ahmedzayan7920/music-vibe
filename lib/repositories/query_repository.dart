import 'package:dartz/dartz.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/failure/failure.dart';

class QueryRepository {
  final OnAudioQuery _audioQuery;

  QueryRepository({required OnAudioQuery audioQuery})
      : _audioQuery = audioQuery;

  List<SongModel> _allSongs = [];
  List<PlaylistModel> _allPlaylists = [];
  List<AlbumModel> _allAlbums = [];
  List<ArtistModel> _allArtists = [];
  final Map<int, List<SongModel>> _allPlaylistsSongs = {};

  List<SongModel> get allSongs => _allSongs;
  List<PlaylistModel> get allPlaylists => _allPlaylists;
  List<AlbumModel> get allAlbums => _allAlbums;
  List<ArtistModel> get allArtists => _allArtists;
  Map<int, List<SongModel>> get allPlaylistsSongs => _allPlaylistsSongs;

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
      _allPlaylists = await _audioQuery.queryPlaylists();
      return right(_allPlaylists);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<AlbumModel>>> queryAllAlbums() async {
    try {
      _allAlbums = await _audioQuery.queryAlbums();
      return right(_allAlbums);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<ArtistModel>>> queryAllArtists() async {
    try {
      _allArtists = await _audioQuery.queryArtists();
      return right(_allArtists);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> queryPlaylistSongs({
    required int id,
  }) async {
    try {
      final playlistSongs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
        id,
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );

      List<SongModel> matchedSongs = [];
      _allPlaylistsSongs.remove(id);
      for (var playlistSong in playlistSongs) {
        for (var song in allSongs) {
          if (playlistSong.title == song.title &&
              playlistSong.duration == song.duration) {
            matchedSongs.add(song);
            break;
          }
        }
      }

      _allPlaylistsSongs[id] = matchedSongs;
      return right(matchedSongs);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
