import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../auth/controllers/auth_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({required this.uid, super.key});
  final String uid;
  void navigateToEditProfileScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (data) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 230,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            data.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 15).copyWith(bottom: 50),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(data.profilePic),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: data.uid == user.uid
                              ? OutlinedButton(
                                  onPressed: () {
                                    navigateToEditProfileScreen(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      )),
                                  child: const Text('Edit profile'))
                              : const SizedBox(),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${data.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('${data.karma} karma'),
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Divider(
                          thickness: 2,
                          color: Colors.red.withOpacity(0.3),
                        )
                      ]),
                    ),
                  )
                ];
              },
              body: const Text('Displaying user posts'),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const LoaderInd(),
          ),
    );
  }
}
