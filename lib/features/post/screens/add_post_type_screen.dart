import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../theme/pallete.dart';
import '../../community/controller/community_controller.dart';
import '../controller/post_controller.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({required this.type, super.key});
  final String type;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' && titleController.text.isNotEmpty && bannerFile != null) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' && titleController.text.isNotEmpty && linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return isLoading
        ? const LoaderInd()
        : Scaffold(
            appBar: AppBar(
              title: Text('Post ${widget.type}'),
              actions: [TextButton(onPressed: sharePost, child: const Text('Share'))],
            ),
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      label: Text('Enter title here'),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    maxLength: 20,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        color: currentTheme.textTheme.titleMedium!.color!,
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
                                : const Center(
                                    child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ))),
                      ),
                    ),
                  if (isTypeText)
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        label: Text('Enter description here'),
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 5, left: 8),
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    TextFormField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        label: Text('Enter link here'),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Select community:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ref.watch(userCommunitiesProvider).when(
                            data: (data) {
                              communities = data;
                              if (data.isEmpty) {
                                return const SizedBox();
                              }
                              return DropdownButton(
                                value: selectedCommunity ?? data[0],
                                items: data.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    selectedCommunity = v;
                                  });
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(error: error.toString()),
                            loading: () => const LoaderInd(),
                          )
                    ],
                  )
                ],
              ),
            )),
          );
  }
}
