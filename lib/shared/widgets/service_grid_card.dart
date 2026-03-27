import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Service Grid Card - Szolgáltatás bemutatása grid layoutban
class ServiceGridCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String? duration;
  final String? imageUrl;
  final VoidCallback onTap;
  final bool isLoading;

  const ServiceGridCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.duration,
    this.imageUrl,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kép tetején
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusCard),
                    topRight: Radius.circular(AppSpacing.radiusCard),
                  ),
                  color: AppColors.surfaceVariant,
                ),
                child: _buildImageWidget(),
              ),
            ),
            // Tartalom alul
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      semanticsLabel: title,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: AppTextStyles.heading3.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                                semanticsLabel: 'Ár: $price',
                              ),
                              if (duration != null)
                                Text(
                                  duration!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.textSecondary,
                          semanticLabel: 'Tovább',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return imageUrl != null
        ? ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusCard),
              topRight: Radius.circular(AppSpacing.radiusCard),
            ),
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  color: AppColors.textTertiary,
                );
              },
            ),
          )
        : const Icon(
            Icons.spa,
            color: AppColors.primary,
            size: 48,
            semanticLabel: 'Service image',
          );
  }
}
