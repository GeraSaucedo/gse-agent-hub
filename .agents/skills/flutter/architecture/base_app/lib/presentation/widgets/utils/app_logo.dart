import 'package:material_ui/material_ui.dart';

class AppLogo extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Hero(
      tag: 'app-logo',
      child: FlutterLogo(),
    );
  }
}
