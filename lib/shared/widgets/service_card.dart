import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Service Card - Szolgáltatás bemutatása listában
class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String? duration;
  final String? imageUrl;
  final VoidCallback onTap;
  final bool isLoading;

  const ServiceCard({
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
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder kép vagy valódi kép
              _buildImageWidget(),
              const SizedBox(width: AppSpacing.m),
              // Tartalom
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      semanticsLabel: title,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price,
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                              ),
                              semanticsLabel: 'Ár: $price',
                            ),
                            if (duration != null)
                              Text(
                                duration!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                          semanticLabel: 'Tovább',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        color: AppColors.surfaceVariant,
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
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
              size: 40,
              semanticLabel: 'Service image',
            ),
    );
  }
}
