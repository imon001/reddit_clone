import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../controller/community_controller.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({required this.name, super.key});
  final String name;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? avatarFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.watch(communityControllerProvider.notifier).editCommunity(
          community: community,
          context: context,
          avatarFile: avatarFile,
          bannerFile: bannerFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        loading: () => const LoaderInd(),
        error: (error, stacktrace) => ErrorText(
              error: error.toString(),
            ),
        data: (data) {
          return Scaffold(
            //backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Edit community'),
              actions: [
                TextButton(
                    onPressed: () {
                      save(data);
                    },
                    child: const Text('Save'))
              ],
            ),
            body: isLoading
                ? const LoaderInd()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  color: Colors.grey,
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : data.banner.isEmpty || data.banner == Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ))
                                            : Image.network(
                                                width: double.infinity,
                                                height: double.infinity,
                                                data.banner,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: avatarFile != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(avatarFile!),
                                          radius: 30,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(data.avatar),
                                          radius: 30,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
