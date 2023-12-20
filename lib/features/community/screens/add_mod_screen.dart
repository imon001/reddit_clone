import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controller/community_controller.dart';

class AddModScreen extends ConsumerStatefulWidget {
  const AddModScreen({required this.name, super.key});
  final String name;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};
  int ctr = 0;
  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addmods(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (data) => ListView.builder(
              itemCount: data.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = data.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (userData) {
                        if (data.mods.contains(member) && ctr == 0) {
                          uids.add(member);
                        }
                        ctr++;
                        return CheckboxListTile(
                          value: uids.contains(member) ? true : false,
                          onChanged: (v) {
                            if (v!) {
                              addUid(member);
                            } else {
                              removeUid(member);
                            }
                          },
                          title: Text(userData.name),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const LoaderInd(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const LoaderInd(),
          ),
    );
  }
}
