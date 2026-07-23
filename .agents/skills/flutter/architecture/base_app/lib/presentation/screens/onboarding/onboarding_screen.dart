import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:gse_base_app/core/services/storage/utils/onboarding_manager.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/screens/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const name = 'onboarding-screen';
  static const route = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await sl<OnboardingManager>().completeOnboarding();
    if (mounted) context.go(LoginScreen.route);
  }

  void _nextPage() {
    unawaited(
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  void _previousPage() {
    unawaited(
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLastPage = _currentPage == 2;

    final pages = [
      _OnboardingPage(
        icon: Icons.rocket_launch_outlined,
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDescription1,
      ),
      _OnboardingPage(
        icon: Icons.lock_outline,
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDescription2,
      ),
      _OnboardingPage(
        icon: Icons.check_circle_outline,
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDescription3,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: context.spacing.sm,
                  right: context.spacing.md,
                ),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    l10n.onboardingSkip,
                    style: context.textStyles.labelMed
                        .c(context.colors.textSecondary),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                children: pages,
              ),
            ),

            // Dots indicator
            Padding(
              padding: EdgeInsets.only(bottom: context.spacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacing.xs,
                    ),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? context.colors.primary
                          : context.colors.disabled,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        l10n.onboardingBack,
                        style: context.textStyles.labelMed,
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  // Next / Start button
                  ElevatedButton(
                    onPressed: isLastPage ? _completeOnboarding : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing.lg,
                        vertical: context.spacing.sm,
                      ),
                    ),
                    child: Text(
                      isLastPage ? l10n.onboardingStart : l10n.onboardingNext,
                      style: context.textStyles.labelMed
                          .c(context.colors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.spacing.xl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: context.sp(80),
            color: context.colors.primary,
          ),
          SizedBox(height: context.spacing.lg),
          Text(
            title,
            style: context.textStyles.headMed.c(context.colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing.md),
          Text(
            description,
            style: context.textStyles.bodyMed.c(context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
