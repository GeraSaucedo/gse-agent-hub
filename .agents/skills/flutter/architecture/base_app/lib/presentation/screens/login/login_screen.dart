import 'package:flutter/material.dart';
import 'package:gse_base_app/presentation/screens/login/login_bloc_listener.dart';
import 'package:gse_base_app/presentation/screens/login/login_view.dart';
import 'package:gse_base_app/presentation/widgets/utils/unfocus_on_tap.dart';
import 'package:gse_design_system/gse_design_system.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const name = 'login-screen';
  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return LoginBlocListener(
      child: UnfocusOnTap(
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: context.h(100),
              child: const LoginView(),
            ),
          ),
        ),
      ),
    );
  }
}
