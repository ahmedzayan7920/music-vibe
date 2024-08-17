import 'package:flutter/material.dart';
import 'package:music_vibe/logic/playlists_cubit/playlists_cubit.dart';

import '../../../core/di/dependency_injection.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        TextEditingController controller = TextEditingController();
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Add playlist"),
              content: TextFormField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Playlist name"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getIt<PlaylistsCubit>()
                        .addPlayList(name: controller.text.trim());
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.playlist_add),
    );
  }
}
