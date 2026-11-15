import 'package:gse_base_app/presentation/screens/example_pagination/example_pagination_view.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class ExamplePaginationScreen extends StatelessWidget {
  const new({super.key});

  static const name = 'pagination-example';
  static const path = 'pagination-example';
  static const route = '/$path';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.paginationTitle,
      ),
      body: const ExamplePaginationView(),
    );
  }
}
