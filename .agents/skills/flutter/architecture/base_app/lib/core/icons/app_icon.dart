import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gse_base_app/core/icons/app_icon_name.dart';

/// A widget that displays an SVG icon
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
  });

  static const String _basePath = 'assets/icons';

  /// The icon to display
  final AppIcons icon;

  /// The size of the icon
  final double? size;

  /// The width of the icon
  final double? width;

  /// The height of the icon
  final double? height;

  /// The color to tint the icon with
  final Color? color;

  /// The blend mode to use when tinting the icon
  final BlendMode colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$_basePath/${icon.name}.svg',
      width: width ?? size,
      height: height ?? size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, colorBlendMode)
          : null,
    );
  }
}
