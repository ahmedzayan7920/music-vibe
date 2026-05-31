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
  List<AlbumModel> _allAlbums = [];
  List<ArtistModel> _allArtists = [];
  List<String> _allFolders = [];
  List<int> favoriteIds = [];
  final Map<int, List<SongModel>> _allPlaylistsTracks = {};

  List<SongModel> get allTracks => _allTracks;
  List<PlaylistModel> get allPlaylists => _allPlaylists;
  List<AlbumModel> get allAlbums => _allAlbums;
  List<ArtistModel> get allArtists => _allArtists;
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

  Future<Either<Failure, List<SongModel>>> queryPlaylistTracks({
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

      List<SongModel> matchedTracks = [];
      _allPlaylistsTracks.remove(id);
      for (var playlistSong in playlistSongs) {
        for (var song in allTracks) {
          if (playlistSong.title == song.title &&
              playlistSong.duration == song.duration) {
            matchedTracks.add(song);
            break;
          }
        }
      }

      _allPlaylistsTracks[id] = matchedTracks;
      return right(matchedTracks);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  List<SongModel> queryFavoriteTracks() {
    final allFavoriteTracks =
        _allTracks.where((song) => favoriteIds.contains(song.id)).toList();
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
      _allFolders = await _audioQuery.queryAllPath();
      return right(_allFolders);
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  Future<Either<Failure, List<SongModel>>> queryFolderTracks(
      {required String folder}) async {
    try {
      return right(await _audioQuery.querySongs(path: folder));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
