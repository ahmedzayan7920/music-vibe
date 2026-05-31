import 'package:flutter/material.dart';
import 'package:sonic_vibe/core/di/dependency_injection.dart';
import 'package:sonic_vibe/repositories/query_repository.dart';
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
  late List<SongModel> tracks;

  @override
  void initState() {
    tracks = getIt<QueryRepository>().allTracks.where(
      (track) {
        if (widget.type == AudiosFromType.ALBUM) {
          return track.album == widget.title;
        } else if (widget.type == AudiosFromType.GENRE) {
          return track.data.contains(widget.title);
        } else {
          return track.artist == widget.title;
        }
      },
    ).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (tracks.isEmpty)
          ? const EmptyState(message: 'No Sounds Found')
          : Column(
              children: [
                tracks.isEmpty
                    ? const SizedBox()
                    : ShuffleListTile(songs: tracks),
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
