import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

/// Pantalla de showcase del Design System.
class DesignSystemDemoScreen extends StatelessWidget {
  const DesignSystemDemoScreen({super.key});

  static const name = 'design-system-demo';
  static const route = '/design-system-demo';

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              AppLocalizations.of(context)!.dsTitle,
              style: context.textStyles.titleLarge.semibold,
            ),
            actions: const [_ThemeToggle()],
          ),
          SliverPadding(
            padding: EdgeInsets.all(sp.md),
            sliver: SliverList.list(
              children: [
                _SectionHeader(AppLocalizations.of(context)!.dsTypography),
                SizedBox(height: sp.sm),
                const _TypographyByRole(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsWeights),
                SizedBox(height: sp.sm),
                const _WeightsShowcase(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsTextStyles),
                SizedBox(height: sp.sm),
                const _StylesShowcase(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsColors),
                SizedBox(height: sp.sm),
                _ColorGrid(colors: context.colors),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsOpacity),
                SizedBox(height: sp.sm),
                const _OpacityShowcase(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsSpacing),
                SizedBox(height: sp.sm),
                const _SpacingShowcase(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsBorderRadius),
                SizedBox(height: sp.sm),
                const _RadiusShowcase(),
                SizedBox(height: sp.lg),
                _SectionHeader(AppLocalizations.of(context)!.dsComponents),
                SizedBox(height: sp.sm),
                const _ComponentsShowcase(),
                SizedBox(height: sp.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme toggle ────────────────────────────────────────────────

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final ds = DSProvider.of(context);
    return IconButton(
      onPressed: ds.toggleTheme,
      icon: Icon(
        ds.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.spacing.sm),
      child: Text(
        title.toUpperCase(),
        style: context.textStyles.labelMed.bold.c(context.colors.primary),
      ),
    );
  }
}

// ── Typography by role ──────────────────────────────────────────

class _TypographyByRole extends StatelessWidget {
  const _TypographyByRole();

  @override
  Widget build(BuildContext context) {
    final ts = context.textStyles;
    final sec = context.colors.textSecondary;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head
            _roleHeader(context, 'Head'),
            _styleTile(context, 'headLarge', ts.headLarge, '28sp w700', sec),
            _styleTile(context, 'headMed', ts.headMed, '24sp w700', sec),
            _styleTile(context, 'headSmall', ts.headSmall, '20sp w600', sec),
            _divider(context),

            // Title
            _roleHeader(context, 'Title'),
            _styleTile(context, 'titleLarge', ts.titleLarge, '18sp w600', sec),
            _styleTile(context, 'titleMed', ts.titleMed, '16sp w600', sec),
            _styleTile(context, 'titleSmall', ts.titleSmall, '14sp w600', sec),
            _divider(context),

            // Body
            _roleHeader(context, 'Body'),
            _styleTile(context, 'bodyLarge', ts.bodyLarge, '16sp w400', sec),
            _styleTile(context, 'bodyMed', ts.bodyMed, '14sp w400', sec),
            _styleTile(context, 'bodySmall', ts.bodySmall, '12sp w400', sec),
            _divider(context),

            // Label
            _roleHeader(context, 'Label'),
            _styleTile(context, 'labelLarge', ts.labelLarge, '14sp w500', sec),
            _styleTile(context, 'labelMed', ts.labelMed, '12sp w500', sec),
            _styleTile(context, 'labelSmall', ts.labelSmall, '11sp w500', sec),
            _divider(context),

            // Caption
            _roleHeader(context, 'Caption'),
            _styleTile(
              context,
              'captionMed',
              ts.captionMed,
              '12sp w400',
              sec,
            ),
            _styleTile(
              context,
              'captionSmall',
              ts.captionSmall,
              '10sp w400',
              sec,
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleHeader(BuildContext context, String role) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.spacing.sm,
        bottom: context.spacing.xs,
      ),
      child: Text(
        role,
        style: context.textStyles.labelSmall.bold.c(context.colors.primary),
      ),
    );
  }

  Widget _styleTile(
    BuildContext context,
    String name,
    TextStyle style,
    String spec,
    Color specColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.dsExampleText, style: style),
          const SizedBox(height: 2),
          Text(
            '$name  ·  $spec',
            style: context.textStyles.captionSmall.c(specColor),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      child: Divider(color: context.colors.onSurfaceLow),
    );
  }
}

// ── Weights showcase ────────────────────────────────────────────

class _WeightsShowcase extends StatelessWidget {
  const _WeightsShowcase();

  @override
  Widget build(BuildContext context) {
    final ts = context.textStyles;
    final sec = context.colors.textSecondary;

    final weights = [
      ('thin', ts.bodyLarge.thin, 'w100'),
      ('light', ts.bodyLarge.light, 'w300'),
      ('regular', ts.bodyLarge.regular, 'w400'),
      ('medium', ts.bodyLarge.medium, 'w500'),
      ('semibold', ts.bodyLarge.semibold, 'w600'),
      ('bold', ts.bodyLarge.bold, 'w700'),
      ('heavy', ts.bodyLarge.heavy, 'w800'),
      ('black', ts.bodyLarge.black, 'w900'),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: weights.map((w) {
            final (name, style, code) = w;
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.spacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.dsWeightLabel(name),
                      style: style,
                    ),
                  ),
                  Text(
                    '.$name ($code)',
                    style: context.textStyles.captionSmall.c(sec),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Styles showcase ─────────────────────────────────────────────

class _StylesShowcase extends StatelessWidget {
  const _StylesShowcase();

  @override
  Widget build(BuildContext context) {
    final ts = context.textStyles;
    final colors = context.colors;
    final sec = colors.textSecondary;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.spacing.sm,
          children: [
            // Italic
            _row(
              context,
              AppLocalizations.of(context)!.dsItalicText,
              ts.bodyMed.italic,
              '.italic',
              sec,
            ),
            // Underline
            _row(
              context,
              AppLocalizations.of(context)!.dsUnderlineText,
              ts.bodyMed.underline,
              '.underline',
              sec,
            ),
            // Strikethrough
            _row(
              context,
              AppLocalizations.of(context)!.dsStrikethroughText,
              ts.bodyMed.strikethrough,
              '.strikethrough',
              sec,
            ),
            Divider(color: colors.onSurfaceLow),

            // Combinaciones
            Text(
              AppLocalizations.of(context)!.dsCombinations,
              style: ts.labelSmall.bold.c(colors.primary),
            ),
            _row(
              context,
              'Bold + Italic',
              ts.bodyMed.bold.italic,
              '.bold.italic',
              sec,
            ),
            _row(
              context,
              'Semibold + Underline',
              ts.bodyMed.semibold.underline,
              '.semibold.underline',
              sec,
            ),
            _row(
              context,
              'Heavy + Color',
              ts.bodyMed.heavy.c(colors.error),
              '.heavy.c(error)',
              sec,
            ),
            Divider(color: colors.onSurfaceLow),

            // Color
            Text('Color .c()', style: ts.labelSmall.bold.c(colors.primary)),
            _row(
              context,
              'Primary',
              ts.bodyMed.c(colors.primary),
              '.c(primary)',
              sec,
            ),
            _row(
              context,
              'Error',
              ts.bodyMed.c(colors.error),
              '.c(error)',
              sec,
            ),
            _row(
              context,
              'Success',
              ts.bodyMed.c(colors.success),
              '.c(success)',
              sec,
            ),
            _row(
              context,
              'Warning',
              ts.bodyMed.c(colors.warning),
              '.c(warning)',
              sec,
            ),
            _row(context, 'Info', ts.bodyMed.c(colors.info), '.c(info)', sec),
            Divider(color: colors.onSurfaceLow),

            // String.upper
            Text("'texto'.upper", style: ts.labelSmall.bold.c(colors.primary)),
            Text(
              AppLocalizations.of(context)!.dsActiveState.upper,
              style: ts.titleMed.semibold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String text,
    TextStyle style,
    String code,
    Color codeColor,
  ) {
    return Row(
      children: [
        Expanded(child: Text(text, style: style)),
        Text(code, style: context.textStyles.captionSmall.c(codeColor)),
      ],
    );
  }
}

// ── Colors ──────────────────────────────────────────────────────

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({required this.colors});
  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final groups = [
      (
        AppLocalizations.of(context)!.dsSurfaces,
        [
          ('scaffoldBg', colors.scaffoldBackground),
          ('surface', colors.surface),
          ('onSurfaceLow', colors.onSurfaceLow),
          ('onSurface', colors.onSurface),
          ('onSurfaceHigh', colors.onSurfaceHigh),
        ],
      ),
      (
        AppLocalizations.of(context)!.dsTextGroup,
        [
          ('textPrimary', colors.textPrimary),
          ('textSecondary', colors.textSecondary),
          ('textDisabled', colors.textDisabled),
        ],
      ),
      (
        AppLocalizations.of(context)!.dsBrand,
        [
          ('primary', colors.primary),
          ('onPrimary', colors.onPrimary),
          ('secondary', colors.secondary),
          ('onSecondary', colors.onSecondary),
          ('accent', colors.accent),
          ('onAccent', colors.onAccent),
        ],
      ),
      (
        AppLocalizations.of(context)!.dsStateGroup,
        [
          ('disabled', colors.disabled),
          ('onDisabled', colors.onDisabled),
        ],
      ),
      (
        AppLocalizations.of(context)!.dsSemantic,
        [
          ('error', colors.error),
          ('onError', colors.onError),
          ('success', colors.success),
          ('onSuccess', colors.onSuccess),
          ('warning', colors.warning),
          ('onWarning', colors.onWarning),
          ('info', colors.info),
          ('onInfo', colors.onInfo),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.map((group) {
        final (label, tokens) = group;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: context.spacing.sm,
                bottom: context.spacing.xs,
              ),
              child: Text(
                label,
                style: context.textStyles.labelSmall.bold.c(
                  context.colors.primary,
                ),
              ),
            ),
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: tokens
                  .map((t) => _ColorSwatch(name: t.$1, color: t.$2))
                  .toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.name, required this.color});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    final hex = '#$r$g$b'.toUpperCase();

    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(context.radius.md),
              border: Border.all(color: context.colors.onSurface),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: context.textStyles.captionSmall.medium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            hex,
            style: context.textStyles.captionSmall.c(
              context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Opacity showcase ────────────────────────────────────────────

class _OpacityShowcase extends StatelessWidget {
  const _OpacityShowcase();

  @override
  Widget build(BuildContext context) {
    final base = context.colors.primary;
    final levels = [
      ('o10', base.o10, '10%'),
      ('o20', base.o20, '20%'),
      ('o50', base.o50, '50%'),
      ('o80', base.o80, '80%'),
      ('base', base, '100%'),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          children: levels.map((l) {
            final (name, color, pct) = l;
            return Expanded(
              child: Column(
                children: [
                  Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(
                        context.radius.md,
                      ),
                    ),
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    '.$name',
                    style: context.textStyles.captionSmall.medium,
                  ),
                  Text(
                    pct,
                    style: context.textStyles.captionSmall.c(
                      context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Spacing ─────────────────────────────────────────────────────

class _SpacingShowcase extends StatelessWidget {
  const _SpacingShowcase();

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final tokens = [
      ('xs', sp.xs),
      ('sm', sp.sm),
      ('md', sp.md),
      ('lg', sp.lg),
      ('xl', sp.xl),
      ('xxl', sp.xxl),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(sp.md),
        child: Column(
          spacing: sp.sm,
          children: tokens.map((t) {
            final (label, value) = t;
            return Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    label,
                    style: context.textStyles.labelMed.semibold,
                  ),
                ),
                SizedBox(width: sp.sm),
                Container(
                  height: 14,
                  width: value,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: sp.xs),
                Text(
                  '${value.toStringAsFixed(0)}px',
                  style: context.textStyles.captionSmall.c(
                    context.colors.textSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Radius ──────────────────────────────────────────────────────

class _RadiusShowcase extends StatelessWidget {
  const _RadiusShowcase();

  @override
  Widget build(BuildContext context) {
    final r = context.radius;
    final tokens = [
      ('sm', r.sm),
      ('md', r.md),
      ('lg', r.lg),
      ('xl', r.xl),
      ('circular', r.circular),
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tokens.map((t) {
            final (label, value) = t;
            return Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: context.colors.primary.o20,
                    border: Border.all(
                      color: context.colors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(value),
                  ),
                ),
                SizedBox(height: context.spacing.xs),
                Text(label, style: context.textStyles.labelSmall.semibold),
                Text(
                  '${value == 999 ? '999' : value.toStringAsFixed(0)}px',
                  style: context.textStyles.captionSmall.c(
                    context.colors.textSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Components ──────────────────────────────────────────────────

class _ComponentsShowcase extends StatelessWidget {
  const _ComponentsShowcase();

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: sp.sm,
      children: [
        FilledButton(
          onPressed: () {},
          child: const Text('FilledButton'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Text('OutlinedButton'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('TextButton'),
        ),
        const FilledButton(
          onPressed: null,
          child: Text('Disabled'),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(sp.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: sp.xs,
              children: [
                Text('Card', style: context.textStyles.titleSmall.semibold),
                Text(
                  AppLocalizations.of(context)!.dsCardDescription,
                  style: context.textStyles.bodySmall.c(
                    context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'TextField',
            hintText: AppLocalizations.of(context)!.dsTextFieldHint,
          ),
        ),
        Row(
          spacing: sp.sm,
          children: [
            Chip(label: Text('Chip', style: context.textStyles.labelSmall)),
            InputChip(
              label: Text('Input', style: context.textStyles.labelSmall),
              onPressed: () {},
            ),
            FilterChip(
              label: Text('Filter', style: context.textStyles.labelSmall),
              selected: true,
              onSelected: (_) {},
            ),
          ],
        ),
      ],
    );
  }
}
