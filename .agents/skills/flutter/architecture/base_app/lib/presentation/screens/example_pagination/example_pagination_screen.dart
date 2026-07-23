import 'package:flutter/material.dart';
import 'package:gse_base_app/presentation/screens/example_pagination/example_pagination_view.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';

class ExamplePaginationScreen extends StatelessWidget {
  const ExamplePaginationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Pagination'),
      body: ExamplePaginationView(),
    );
  }
}
