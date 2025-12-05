import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/failure/failure.dart';

class QueryRepository {
  final OnAudioQuery _audioQuery;
  final SharedPreferences _sharedPreferences;

  QueryRepository(
      {required OnAudioQuery audioQuery,
      required SharedPreferences sharedPreferences})
      : _audioQuery = audioQuery,
        _sharedPreferences = sharedPreferences {
    _getFavoriteIds();
  }

  List<SongModel> _allSongs = [];
  List<PlaylistModel> _allPlaylists = [];
  List<AlbumModel> _allAlbums = [];
  List<ArtistModel> _allArtists = [];
  List<String> _allFolders = [];
  List<int> favoriteIds = [];
  final Map<int, List<SongModel>> _allPlaylistsSongs = {};

  List<SongModel> get allSongs => _allSongs;
  List<PlaylistModel> get allPlaylists => _allPlaylists;
  List<AlbumModel> get allAlbums => _allAlbums;
  List<ArtistModel> get allArtists => _allArtists;
  List<String> get allFolders => _allFolders;
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
      // On iOS, the on_audio_query plugin can crash when there are no playlists
      // or when the Music library is empty (common on simulators).
      // We skip the native query on iOS to prevent the app from crashing.
      if (Platform.isIOS) {
        _allPlaylists = [];
        return right(_allPlaylists);
      }
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
      // On iOS, playlists are disabled due to plugin crash issues
      if (Platform.isIOS) {
        return right(<SongModel>[]);
      }
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

  List<SongModel> queryFavoriteSongs() {
    final allFavoriteSongs =
        _allSongs.where((song) => favoriteIds.contains(song.id)).toList();
    return allFavoriteSongs;
  }

  List<SongModel> toggleFavorite({required int id}) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      _sharedPreferences.setStringList(
          "favorite", favoriteIds.map((e) => e.toString()).toList());
      return queryFavoriteSongs();
    } else {
      favoriteIds.add(id);
      _sharedPreferences.setStringList(
          "favorite", favoriteIds.map((e) => e.toString()).toList());
      return queryFavoriteSongs();
    }
  }

  void _getFavoriteIds() {
    favoriteIds = _sharedPreferences
            .getStringList("favorite")
            ?.map(
              (e) => int.parse(e),
            )
            .toList() ??
        [];
  }

  Future<Either<Failure, List<String>>> queryAllFolders() async {
    try {
      // Folders are not supported on iOS due to plugin limitations
      if (Platform.isIOS) {
        _allFolders = [];
        return right(_allFolders);
      }
      _allFolders = await _audioQuery.queryAllPath();
      return right(_allFolders);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> queryFolderSongs(
      {required String folder}) async {
    try {
      // Folders are not supported on iOS due to plugin limitations
      if (Platform.isIOS) {
        return right(<SongModel>[]);
      }
      return right(await _audioQuery.querySongs(path: folder));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
