import 'package:material_ui/material_ui.dart';

class AppLoader extends StatelessWidget {
  const new({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
    );
  }
}
