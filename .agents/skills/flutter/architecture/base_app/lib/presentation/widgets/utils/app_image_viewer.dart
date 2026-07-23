import 'dart:io';

import 'package:flutter/material.dart';

class AppImageViewer extends StatefulWidget {
  const AppImageViewer({
    required this.imageFile,
    super.key,
  });

  final File imageFile;

  @override
  State<AppImageViewer> createState() => _AppImageViewerState();
}

class _AppImageViewerState extends State<AppImageViewer> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = details.localPosition;
      final matrix = Matrix4.identity()
        ..setEntry(0, 3, -position.dx)
        ..setEntry(1, 3, -position.dy)
        ..setEntry(0, 0, 2)
        ..setEntry(1, 1, 2)
        ..setEntry(2, 2, 2);
      _transformationController.value = matrix;
    }
  }

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
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 4,
          child: Center(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showImageViewer(BuildContext context, File imageFile) async {
  await Navigator.push(
    context,
    MaterialPageRoute<dynamic>(
      builder: (context) => AppImageViewer(imageFile: imageFile),
    ),
  );
}
