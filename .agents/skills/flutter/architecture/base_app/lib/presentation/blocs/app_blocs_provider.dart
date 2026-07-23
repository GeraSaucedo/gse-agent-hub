import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/blocs/auth/auth_cubit.dart';

class AppBlocProvider extends StatelessWidget {
  const AppBlocProvider({required this.child, super.key});

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
