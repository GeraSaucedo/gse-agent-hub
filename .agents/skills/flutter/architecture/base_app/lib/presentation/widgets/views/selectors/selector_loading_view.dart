import 'package:flutter/material.dart';

class SelectorLoadingView extends StatelessWidget {
  const SelectorLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
