import 'package:material_ui/material_ui.dart';

class UnfocusOnTap extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This line of code unfocuses the current focus when
        // tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
