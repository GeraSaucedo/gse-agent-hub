import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:material_ui/material_ui.dart';

class AppBlocProvider extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App base blocs
        BlocProvider.value(value: sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<AppBloc>()),
      ],
      child: child,
    );
  }
}
