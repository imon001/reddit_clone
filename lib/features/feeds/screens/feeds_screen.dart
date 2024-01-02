import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../community/controller/community_controller.dart';
import '../../post/controller/post_controller.dart';

class FeedsScreen extends ConsumerWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (data) => ref.watch(userPostsProvider(data)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const LoaderInd(),
                ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const LoaderInd(),
          );
    }
    return ref.watch(userCommunitiesProvider).when(
          data: (data) => ref.watch(guestPostsProvider).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const LoaderInd(),
              ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoaderInd(),
        );
  }
}
