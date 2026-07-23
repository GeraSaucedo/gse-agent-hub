/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppImageNetworkViewer extends StatelessWidget {
  final String imageUrl;

  const AppImageNetworkViewer({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: context.sp(32),
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    'Error al cargar la imagen',
                    style: context.textStyles.titleMed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showImageNetworkViewer(BuildContext context, String imageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AppImageNetworkViewer(imageUrl: imageUrl),
    ),
  );
}
 */
