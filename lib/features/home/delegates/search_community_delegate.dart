import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../community/controller/community_controller.dart';

class SearchCommunityDelegate extends SearchDelegate {
  SearchCommunityDelegate(this.ref);

  final WidgetRef ref;
  void navigateToCommunityScreen(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final community = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar),
                  ),
                  title: Text('r/${community.name}'),
                  onTap: () => navigateToCommunityScreen(context, community.name),
                );
              },
            ),
        error: (error, stacktrace) => ErrorText(error: error.toString()),
        loading: () => const LoaderInd());
  }
}
