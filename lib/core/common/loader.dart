import 'package:flutter/material.dart';

class LoaderInd extends StatelessWidget {
  const LoaderInd({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
