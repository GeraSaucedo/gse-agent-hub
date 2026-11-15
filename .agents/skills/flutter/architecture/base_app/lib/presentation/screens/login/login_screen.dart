import 'package:gse_base_app/presentation/screens/login/login_bloc_listener.dart';
import 'package:gse_base_app/presentation/screens/login/login_view.dart';
import 'package:gse_base_app/presentation/widgets/utils/unfocus_on_tap.dart';
import 'package:material_ui/material_ui.dart';

class LoginScreen extends StatelessWidget {
  const new({super.key});

  static const name = 'login-screen';
  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return LoginBlocListener(
      child: UnfocusOnTap(
        child: Scaffold(
          // At least the screen height (so the view's Spacers center it),
          // but free to grow and scroll on small screens or with the
          // keyboard open; a fixed h(100) overflowed there.
          body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const IntrinsicHeight(child: LoginView()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
