import 'package:flutter/material.dart';
import 'package:music_vibe/core/di/dependency_injection.dart';
import 'package:music_vibe/repositories/query_repository.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

import '../widgets/common/empty_state.dart';
import '../widgets/common/shuffle_list_tile.dart';
import '../widgets/common/track_list_tile.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({super.key, required this.title, required this.type});

  final String title;
  final AudiosFromType type;

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  List<SongModel> tracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    if (widget.type == AudiosFromType.GENRE) {
      // Type GENRE was repurposed for Folders in this app's navigation
      final result = await getIt<QueryRepository>()
          .queryFolderSongs(folder: widget.title);
      result.fold(
        (failure) => setState(() {
          tracks = [];
          isLoading = false;
        }),
        (songs) => setState(() {
          tracks = songs;
          isLoading = false;
        }),
      );
    } else {
      setState(() {
        tracks = getIt<QueryRepository>().allTracks.where(
          (song) {
            if (widget.type == AudiosFromType.ALBUM) {
              return song.album == widget.title;
            } else {
              return song.artist?.contains(widget.title) ?? false;
            }
          },
        ).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (tracks.isEmpty)
              ? const EmptyState(message: 'No Sounds Found')
              : Column(
                  children: [
                    tracks.isEmpty
                        ? const SizedBox()
                        : ShuffleListTile(tracks: tracks),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          return TrackListTile(
                              allTracks: tracks, track: tracks[index]);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
