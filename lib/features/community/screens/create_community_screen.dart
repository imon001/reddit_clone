import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../theme/pallete.dart';
import '../controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: isLoading
          ? const LoaderInd()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(alignment: Alignment.topLeft, child: Text('Community name')),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: communityNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      label: Text('r/Community_name'),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                    ),
                    maxLength: 30,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: createCommunity,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 38),
                        backgroundColor: Pallete.blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Create community",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
