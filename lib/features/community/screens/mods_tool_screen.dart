import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  const ModToolsScreen({required this.name, super.key});
  final String name;

  void nevigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void nevigateToAddModsScreen(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderators'),
            onTap: () {
              nevigateToAddModsScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () {
              nevigateToEditCommunityScreen(context);
            },
          ),
        ],
      ),
    );
  }
}
