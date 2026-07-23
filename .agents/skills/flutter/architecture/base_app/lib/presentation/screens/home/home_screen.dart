import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/screens/home/error_initial_data_screen.dart';
import 'package:gse_base_app/presentation/screens/home/home_view.dart';
import 'package:gse_base_app/presentation/screens/home/loading_initial_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<AppBloc>().add(const GetAppConfig());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state.errorMessage != '') {
          return const ErrorInitialDataScreen(
            text: 'Error al obtener los datos del usuario',
          );
        }

        if (state.dataLoaded) {
          return const HomeView();
        }

        return const LoadingInitialDataScreen();
      },
    );
  }
}
