import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Loading Indicator - különböző típusú loading state-ek
class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingMessage;
  final LoadingType type;

  const LoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingMessage,
    this.type = LoadingType.spinner,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Stack(
      children: [
        child,
        Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoadingWidget(),
                if (loadingMessage != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    loadingMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                    semanticsLabel: loadingMessage,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    switch (type) {
      case LoadingType.spinner:
        return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
          strokeWidth: 3,
        );
      case LoadingType.linearProgress:
        return const LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
          minHeight: 4,
        );
    }
  }
}

/// Shimmer Loading - cikk-cakk animáció (UX improvement)
class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSpacing.radiusM),
        ),
      ),
    );
  }
}

/// Shimmer listaelem - több shimmer sorokkal
class ShimmerListItem extends StatelessWidget {
  final int lines;
  final double spacing;

  const ShimmerListItem({
    super.key,
    this.lines = 3,
    this.spacing = AppSpacing.s,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: ShimmerLoading(
            height: index == 0 ? 20 : 14,
            width: index == 0 ? 200 : double.infinity,
            borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          ),
        ),
      ),
    );
  }
}

enum LoadingType { spinner, linearProgress }
