import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/data/repositories/config/config_failures.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/screens/home/error_initial_data_screen.dart';
import 'package:gse_base_app/presentation/screens/home/home_view.dart';
import 'package:gse_base_app/presentation/screens/home/loading_initial_data_screen.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  static const name = 'home';
  static const route = '/';

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
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => switch (state.status) {
        AppStatus.loading => const LoadingInitialDataScreen(),
        AppStatus.loaded => const HomeView(),
        AppStatus.failure => ErrorInitialDataScreen(
          text: switch (state.failure) {
            ConfigFailure.network => l10n.genericNetworkFailureError,
            ConfigFailure.server => l10n.genericServerFailureError,
            ConfigFailure.unknown || null => l10n.errorServerConnectionMessage,
          },
        ),
      },
    );
  }
}
