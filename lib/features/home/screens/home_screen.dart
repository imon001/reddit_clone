import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_two/features/auth/controllers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logOut();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Center(
          child: Text(
        user?.name ?? 'no name',
        style: const TextStyle(color: Colors.blue),
      )),
    );
  }
}
