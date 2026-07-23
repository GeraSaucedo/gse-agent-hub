import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: Image.asset('assets/imgs/logo.png'),
    );
  }
}
