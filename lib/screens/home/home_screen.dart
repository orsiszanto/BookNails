import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Home képernyő - Szalon bemutatása
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('BookNails'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthCubit>().signOut();
            context.goNamed('login');
          },
          tooltip: 'Kijelentkezés',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.pushNamed('profile');
            },
            tooltip: 'Felhasználó profil megnyitása',
          ),
        ],
      ),
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero szalon bemutatása
            Container(
              width: double.infinity,
              height: isMobile ? 200 : 300,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.spa,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Szépségszalon',
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.white,
                    ),
                    semanticsLabel: 'Szépségszalon - Főcím',
                  ),
                  const SizedBox(height: AppSpacing.s),
                  const Text(
                    'Profizs körmös szolgáltatások',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    semanticsLabel: 'Profizs körmös szolgáltatások - Leírás',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            // Info kártyák
            _buildInfoSection(context),
            const SizedBox(height: AppSpacing.l),
            // CTA gombok
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed('services');
                    },
                    icon: const Icon(Icons.spa),
                    label: const Text('Szolgáltatások'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Információ',
          style: AppTextStyles.heading3,
          semanticsLabel: 'Információ - Alszekció fejléc',
        ),
        const SizedBox(height: AppSpacing.m),
        _buildInfoCard(
          icon: Icons.location_on,
          title: 'Cím',
          subtitle: '1234 Budapest, Utca 42.',
        ),
        const SizedBox(height: AppSpacing.s),
        _buildInfoCard(
          icon: Icons.phone,
          title: 'Telefonszám',
          subtitle: '+36 1 234 5678',
        ),
        const SizedBox(height: AppSpacing.s),
        _buildInfoCard(
          icon: Icons.access_time,
          title: 'Nyitva tartás',
          subtitle: 'Hétfő - Péntek: 9:00 - 18:00',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge,
                    semanticsLabel: title,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
