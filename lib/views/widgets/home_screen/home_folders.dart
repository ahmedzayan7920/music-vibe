import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../logic/folders_cubit/folders_cubit.dart';
import '../../../logic/folders_cubit/folders_state.dart';
import '../common/folder_list_tile.dart';

class HomeFolders extends StatelessWidget {
  const HomeFolders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FoldersCubit>()..queryAllFolders(),
      child: BlocBuilder<FoldersCubit, FoldersState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is FoldersSuccessState) {
            List<String> allFolders = state.allFolders;
            if (allFolders.isEmpty) {
              return RefreshIndicator(
              onRefresh: () async {
                context.read<FoldersCubit>().refreshQueryAllFolders();
              },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "No Folders Found",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FoldersCubit>().refreshQueryAllFolders();
              },
              child: ListView.builder(
                itemCount: allFolders.length,
                itemBuilder: (context, index) {
                  String folder = allFolders[index];
                  return FolderListTile(
                    folder: folder,
                  );
                },
              ),
            );
          } else if (state is FoldersFailureState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}