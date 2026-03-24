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
    _loadSoftDeletedItems();
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
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
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
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
      _allPlaylists = await _audioQuery.queryPlaylists();
      
      // Filter out deleted playlists (MediaScanner might be stale on Android 10+)
      _allPlaylists.removeWhere((p) => p.data != null && !File(p.data!).existsSync());
      
      // Filter out soft-deleted playlists (emulator / Android 10+ limitation fallback)
      _allPlaylists.removeWhere((p) => deletedPlaylistIds.contains(p.id));
      
      return right(_allPlaylists);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<AlbumModel>>> queryAllCollections() async {
    try {
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
      _allCollections = await _audioQuery.queryAlbums();
      return right(_allCollections);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<ArtistModel>>> queryAllCreators() async {
    try {
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
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
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
      List<SongModel> playlistTracks =
          await _audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, id);
      List<SongModel> matchedTracks = [];
      Set<int> addedTrackIds = {};
      _allPlaylistsTracks.remove(id);
      
      final softDeletedTracks = deletedTracksFromPlaylists[id] ?? [];
      
      for (var playlistTrack in playlistTracks) {
        for (var track in allTracks) {
          if (playlistTrack.title == track.title &&
              playlistTrack.duration == track.duration &&
              !addedTrackIds.contains(track.id) &&
              !softDeletedTracks.contains(track.id)) {
            matchedTracks.add(track);
            addedTrackIds.add(track.id);
            break; // Stop searching once we find a match for this playlist track
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

  Future<List<SongModel>> toggleFavorite({required int id}) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
      await _sharedPreferences.setStringList(
          "favorite", favoriteIds.map((e) => e.toString()).toList());
      return queryFavoriteTracks();
    } else {
      favoriteIds.add(id);
      await _sharedPreferences.setStringList(
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

  // Soft deletion tracking to handle Android 10+ Scoped Storage restrictions
  List<int> deletedPlaylistIds = [];
  Map<int, List<int>> deletedTracksFromPlaylists = {};

  void _loadSoftDeletedItems() {
    final deletedPlaylistsStr = _sharedPreferences.getStringList("deletedPlaylists") ?? [];
    deletedPlaylistIds = deletedPlaylistsStr.map((e) => int.parse(e)).toList();

    final keys = _sharedPreferences.getKeys().where((k) => k.startsWith("deletedTracks_"));
    for (var key in keys) {
      final pIdStr = key.replaceFirst("deletedTracks_", "");
      if (int.tryParse(pIdStr) != null) {
        final pId = int.parse(pIdStr);
        final list = _sharedPreferences.getStringList(key) ?? [];
        deletedTracksFromPlaylists[pId] = list.map((e) => int.parse(e)).toList();
      }
    }
  }

  Future<void> softDeletePlaylist(int id) async {
    if (!deletedPlaylistIds.contains(id)) {
      deletedPlaylistIds.add(id);
      await _sharedPreferences.setStringList(
          "deletedPlaylists", deletedPlaylistIds.map((e) => e.toString()).toList());
    }
    _allPlaylists.removeWhere((p) => p.id == id);
  }

  Future<void> softDeleteTrackFromPlaylist(int playlistId, int trackId) async {
    final list = deletedTracksFromPlaylists[playlistId] ?? [];
    if (!list.contains(trackId)) {
      list.add(trackId);
      deletedTracksFromPlaylists[playlistId] = list;
      await _sharedPreferences.setStringList(
          "deletedTracks_$playlistId", list.map((e) => e.toString()).toList());
    }
    if (_allPlaylistsTracks[playlistId] != null) {
      _allPlaylistsTracks[playlistId]!.removeWhere((t) => t.id == trackId);
    }
  }

  Future<Either<Failure, List<String>>> queryAllFolders() async {
    try {
      if (Platform.isIOS) {
        _allFolders = [];
        return right(_allFolders);
      }
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
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
      if (Platform.isIOS) {
        return right(<SongModel>[]);
      }
      final hasPermission = await _audioQuery.permissionsStatus();
      if (!hasPermission) {
        return left(Failure(message: "No library access"));
      }
      return right(await _audioQuery.querySongs(path: folder));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
