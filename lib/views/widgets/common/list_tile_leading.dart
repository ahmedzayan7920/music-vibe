import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

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
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: QueryArtworkWidget(
          controller: getIt<OnAudioQuery>(),
          id: id,
          type: type,
          nullArtworkWidget: Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              placeholderIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
