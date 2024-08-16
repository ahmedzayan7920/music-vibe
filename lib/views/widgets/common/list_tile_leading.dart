import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/di/dependency_injection.dart';

class ListTileLeading extends StatelessWidget {
  const ListTileLeading({
    super.key,
    required this.id,
    required this.type,
    required this.placeholderIcon,
  });

  final int id;
  final ArtworkType type;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Center(
        child: QueryArtworkWidget(
          controller: getIt<OnAudioQuery>(),
          id: id,
          type: type,
          nullArtworkWidget: Icon(placeholderIcon),
        ),
      ),
    );
  }
}
