import 'package:flutter/material.dart';

import 'add_remove_favorite_icon.dart';

class TrackListTileTrailing extends StatelessWidget {
  const TrackListTileTrailing({
    super.key,
    required this.trackId,
  });

  final int trackId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: trackId),
      ],
    );
  }
}
