import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({required this.uid, super.key});
  final String uid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;
  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(context: context, avatarFile: profileFile, bannerFile: bannerFile, name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    //final currentTheme = ref.watch(themeNotifierProvider);
    return isLoading
        ? const LoaderInd()
        : ref.watch(getUserDataProvider(widget.uid)).when(
            loading: () => const LoaderInd(),
            error: (error, stacktrace) => ErrorText(
                  error: error.toString(),
                ),
            data: (data) {
              return Scaffold(
                //backgroundColor: currentTheme.backgroundColor,
                appBar: AppBar(
                  title: const Text('Edit profile'),
                  actions: [TextButton(onPressed: save, child: const Text('Save'))],
                ),
                body: Padding(
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
                                // color: currentTheme.textTheme.titleMedium!.color!,
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
                                child: profileFile != null
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(profileFile!),
                                        radius: 30,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(data.profilePic),
                                        radius: 30,
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            label: const Text('Name'),
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue))),
                      )
                    ],
                  ),
                ),
              );
            });
  }
}
