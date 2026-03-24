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

  List<SongModel> _allTracks = [];
  List<PlaylistModel> _allPlaylists = [];
  List<AlbumModel> _allCollections = [];
  List<ArtistModel> _allCreators = [];
  List<String> _allFolders = [];
  List<int> favoriteIds = [];
  final Map<int, List<SongModel>> _allPlaylistsTracks = {};

  List<SongModel> get allTracks => _allTracks;
  List<PlaylistModel> get allPlaylists => _allPlaylists;
  List<AlbumModel> get allCollections => _allCollections;
  List<ArtistModel> get allCreators => _allCreators;
  List<String> get allFolders => _allFolders;
  Map<int, List<SongModel>> get allPlaylistsTracks => _allPlaylistsTracks;

  Future<Either<Failure, List<SongModel>>> queryAllTracks() async {
    try {
      _allTracks = await _audioQuery.querySongs();
      return right(_allTracks);
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

  Future<Either<Failure, List<AlbumModel>>> queryAllCollections() async {
    try {
      _allCollections = await _audioQuery.queryAlbums();
      return right(_allCollections);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<ArtistModel>>> queryAllCreators() async {
    try {
      _allCreators = await _audioQuery.queryArtists();
      return right(_allCreators);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> queryPlaylistTracks({
    required int id,
  }) async {
    try {
      // On iOS, playlists are disabled due to plugin crash issues
      if (Platform.isIOS) {
        return right(<SongModel>[]);
      }
      if (_allPlaylistsTracks[id] != null &&
          _allPlaylistsTracks[id]!.isNotEmpty) {
        return right(_allPlaylistsTracks[id]!);
      }
      List<SongModel> playlistTracks =
          await _audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, id);
      List<SongModel> matchedTracks = [];
      _allPlaylistsTracks.remove(id);
      for (var playlistTrack in playlistTracks) {
        for (var track in allTracks) {
          if (playlistTrack.title == track.title &&
              playlistTrack.duration == track.duration) {
            matchedTracks.add(track);
          }
        }
      }
      _allPlaylistsTracks[id] = matchedTracks;
      return right(_allPlaylistsTracks[id]!);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  List<SongModel> queryFavoriteTracks() {
    final allFavoriteTracks =
        _allTracks.where((track) => favoriteIds.contains(track.id)).toList();
    return allFavoriteTracks;
  }

  List<SongModel> toggleFavorite({required int id}) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      _sharedPreferences.setStringList(
          "favorite", favoriteIds.map((e) => e.toString()).toList());
      return queryFavoriteTracks();
    } else {
      favoriteIds.add(id);
      _sharedPreferences.setStringList(
          "favorite", favoriteIds.map((e) => e.toString()).toList());
      return queryFavoriteTracks();
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
