import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../bloc/cubit/appointment_cubit.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/user_cubit.dart';
import '../../bloc/cubit/service_cubit.dart';
import '../../models/appointment.dart';
import '../../models/user.dart' as app_user;
import '../../models/service.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/empty_error_state.dart';
import '../../shared/widgets/loading_indicator.dart';
import 'profile_edit_dialogs.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;

    final authUser = context.read<AuthCubit>().getCurrentUser();
    if (authUser == null) {
      return;
    }

    await Future.wait([
      context.read<UserCubit>().fetchUser(authUser.uid),
      context.read<AppointmentCubit>().fetchUserAppointments(authUser.uid),
      context.read<ServiceCubit>().fetchServices(),
    ]);
  }

  Future<void> _refreshProfileData() async {
    await _loadProfileData();
  }

  Future<void> _editBasicProfile(
    app_user.User user,
  ) async {
    final saved = await showNameEditDialog(
      context,
      user: user,
    );

    if (!saved || !mounted) return;

    await _refreshProfileData();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profiladatok sikeresen mentve')),
    );
  }

  Future<void> _editPhoneNumber(app_user.User user) async {
    final saved = await showPhoneNumberEditDialog(
      context,
      user: user,
    );

    if (!saved || !mounted) return;

    await _refreshProfileData();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Telefonszám sikeresen mentve')),
    );
  }

  Future<void> _editEmail(
    app_user.User user,
    firebase_auth.User firebaseUser,
  ) async {
    final saved = await showEmailEditDialog(
      context,
      user: user,
      firebaseUser: firebaseUser,
    );

    if (!saved || !mounted) return;

    await _refreshProfileData();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Megerősítő email elküldve az új címre')),
    );
  }

  Future<void> _editPassword() async {
    final saved = await showPasswordEditDialog(
      context,
    );

    if (!saved || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jelszó sikeresen módosítva')),
    );
  }

  Future<void> _deleteAccount(app_user.User user) async {
    final deleted = await showDeleteAccountDialog(
      context,
      user: user,
    );

    if (!deleted || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A fiók sikeresen törölve lett')),
    );

    if (!mounted) return;
    context.goNamed('login');
  }

  void _openAppointmentDetails(Appointment appointment, app_user.User user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foglalás részletei',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _buildDetailRow('Dátum', _formatDate(appointment.appointmentDate)),
                  _buildDetailRow('Kezdés', appointment.startTime),
                  _buildDetailRow('Időtartam', '${appointment.requestedDurationMinutes} perc'),
                  _buildDetailRow('Státusz', _statusLabel(appointment.status)),
                  _buildDetailRow('Szolgáltatás azonosító', appointment.serviceId),
                  _buildDetailRow('Körmös profil', appointment.nailArtistProfileId),
                  _buildDetailRow('Megjegyzés', appointment.note?.trim().isNotEmpty == true ? appointment.note!.trim() : 'Nincs megjegyzés'),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Felhasználói adatok',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  _buildDetailRow('Név', user.name),
                  _buildDetailRow('Email', user.email),
                  _buildDetailRow('Telefonszám', user.phoneNumber ?? 'Nincs megadva'),
                  const SizedBox(height: AppSpacing.l),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Bezárás'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  app_user.User _fallbackUser(firebase_auth.User firebaseUser) {
    return app_user.User(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName?.trim().isNotEmpty == true
          ? firebaseUser.displayName!.trim()
          : 'Felhasználó',
      email: firebaseUser.email ?? '',
      role: 'user',
      phoneNumber: firebaseUser.phoneNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd.').format(date);
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Függőben';
      case 'confirmed':
        return 'Jóváhagyva';
      case 'modification_requested':
        return 'Módosítást kér';
      case 'cancel_requested':
        return 'Lemondást kér';
      case 'cancelled':
        return 'Lemondva';
      case 'rejected':
        return 'Elutasítva';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.success;
      case 'modification_requested':
        return AppColors.info;
      case 'cancel_requested':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.textSecondary;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, _) {
        final firebaseUser = context.read<AuthCubit>().getCurrentUser();

        return AppScaffold(
          appBar: AppBar(
            title: const Text('Profil'),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: _refreshProfileData,
                icon: const Icon(Icons.refresh),
                tooltip: 'Profil frissítése',
              ),
            ],
          ),
          safeArea: true,
          padding: const EdgeInsets.all(AppSpacing.m),
          body: firebaseUser == null
              ? _buildUnauthenticatedState()
              : RefreshIndicator(
                  onRefresh: _refreshProfileData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        if (userState is UserError) {
                          return EmptyState(
                            icon: Icons.error_outline,
                            title: 'Nem sikerült betölteni a profilodat',
                            description: userState.message,
                            action: ElevatedButton.icon(
                              onPressed: _refreshProfileData,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Újrapróbálás'),
                            ),
                          );
                        }

                        if (userState is UserLoading || userState is UserInitial) {
                          return _buildLoadingState();
                        }

                        final user = userState is UserDetailLoaded
                            ? userState.user
                            : _fallbackUser(firebaseUser);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(user, firebaseUser.email ?? ''),
                            const SizedBox(height: AppSpacing.l),
                            _buildProfileDataSection(user, firebaseUser),
                            const SizedBox(height: AppSpacing.l),
                            _buildQuickActionsSection(user, firebaseUser),
                            const SizedBox(height: AppSpacing.l),
                            _buildAppointmentsSection(user),
                            const SizedBox(height: AppSpacing.l),
                            _buildDangerZoneSection(user),
                          ],
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildUnauthenticatedState() {
    return Center(
      child: EmptyState(
        icon: Icons.lock_outline,
        title: 'Bejelentkezés szükséges',
        description: 'A profil megtekintéséhez előbb jelentkezz be.',
        action: ElevatedButton.icon(
          onPressed: () => context.goNamed('login'),
          icon: const Icon(Icons.login),
          label: const Text('Bejelentkezés'),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerLoading(height: 64, width: 64),
              const SizedBox(height: AppSpacing.m),
              const ShimmerLoading(height: 24, width: 180),
              const SizedBox(height: AppSpacing.s),
              const ShimmerLoading(height: 16, width: 220),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        const ShimmerListItem(lines: 4),
        const SizedBox(height: AppSpacing.l),
        const ShimmerListItem(lines: 2),
      ],
    );
  }

  Widget _buildHeader(app_user.User user, String fallbackEmail) {
    final email = user.email.isNotEmpty ? user.email : fallbackEmail;
    final trimmedName = user.name.trim();
    final initial = trimmedName.isNotEmpty ? trimmedName.substring(0, 1).toUpperCase() : 'U';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Center(
              child: Text(
                initial,
                style: AppTextStyles.heading1.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s),
                Wrap(
                  spacing: AppSpacing.s,
                  runSpacing: AppSpacing.s,
                  children: [
                    _buildHeaderChip('Szerep: ${user.role}', Icons.badge),
                    _buildHeaderChip('UID: ${user.uid.substring(0, user.uid.length > 8 ? 8 : user.uid.length)}', Icons.fingerprint),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLargeButton),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDataSection(app_user.User user, firebase_auth.User firebaseUser) {
    return _buildSectionCard(
      title: 'Profiladatok',
      subtitle: 'A profil fő adatai itt jelennek meg.',
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.person,
            title: 'Név',
            value: user.name,
          ),
          const Divider(height: 1),
          _buildInfoTile(
            icon: Icons.phone,
            title: 'Telefonszám',
            value: user.phoneNumber?.isNotEmpty == true ? user.phoneNumber! : 'Nincs megadva',
          ),
          const Divider(height: 1),
          _buildInfoTile(
            icon: Icons.email,
            title: 'Email',
            value: user.email.isNotEmpty ? user.email : (firebaseUser.email ?? ''),
          ),
          const Divider(height: 1),
          _buildInfoTile(
            icon: Icons.lock,
            title: 'Jelszó',
            value: '••••••••',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(
    app_user.User user,
    firebase_auth.User firebaseUser,
  ) {
    return _buildSectionCard(
      title: 'Gyors műveletek',
      subtitle: 'A legfontosabb profil- és biztonsági műveletek.',
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.person,
            title: 'Név módosítása',
            subtitle: 'A megjelenített név átírása',
            onTap: () => _editBasicProfile(user),
          ),
          const Divider(height: 1),
          _buildActionTile(
            icon: Icons.phone,
            title: 'Telefonszám módosítása',
            subtitle: 'Csak a telefonszám frissítése',
            onTap: () => _editPhoneNumber(user),
          ),
          const Divider(height: 1),
          _buildActionTile(
            icon: Icons.email,
            title: 'Email módosítása',
            subtitle: 'Új email cím megadása és mentése',
            onTap: () => _editEmail(user, firebaseUser),
          ),
          const Divider(height: 1),
          _buildActionTile(
            icon: Icons.lock,
            title: 'Jelszó módosítása',
            subtitle: 'Jelenlegi jelszóval történő frissítés',
            onTap: () => _editPassword(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(app_user.User user) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, serviceState) {
        final services = serviceState is ServiceLoaded ? serviceState.services : const <Service>[];

        return BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, appointmentState) {
            return _buildSectionCard(
              title: 'Foglalásaim',
              subtitle: 'Megnézheted a közelmúltbeli és korábbi időpontjaidat.',
              action: TextButton.icon(
                onPressed: () => context.pushNamed('services'),
                icon: const Icon(Icons.add),
                label: const Text('Új foglalás'),
              ),
              child: _buildAppointmentsContent(appointmentState, user, services),
            );
          },
        );
      },
    );
  }

  Widget _buildAppointmentsContent(
    AppointmentState appointmentState,
    app_user.User user,
    List<Service> services,
  ) {
    if (appointmentState is AppointmentLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
        child: ShimmerListItem(lines: 3),
      );
    }

    if (appointmentState is AppointmentError) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Nem sikerült betölteni a foglalásokat',
        description: appointmentState.message,
        action: ElevatedButton.icon(
          onPressed: _refreshProfileData,
          icon: const Icon(Icons.refresh),
          label: const Text('Újrapróbálás'),
        ),
      );
    }

    if (appointmentState is! AppointmentLoaded || appointmentState.appointments.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_month,
        title: 'Még nincs foglalásod',
        description: 'A foglalásaid itt jelennek meg, miután időpontot foglalsz.',
        action: ElevatedButton.icon(
          onPressed: () => context.pushNamed('services'),
          icon: const Icon(Icons.spa),
          label: const Text('Szolgáltatások'),
        ),
      );
    }

    final appointments = appointmentState.appointments;
    return Column(
      children: appointments
          .map(
            (appointment) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s),
              child: _buildAppointmentCard(
                appointment,
                user,
                serviceName: _serviceNameForAppointment(appointment.serviceId, services),
              ),
            ),
          )
          .toList(),
    );
  }

  String _serviceNameForAppointment(String serviceId, List<Service> services) {
    for (final service in services) {
      if (service.id == serviceId) {
        return service.name;
      }
    }
    return serviceId;
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
    app_user.User user, {
    required String serviceName,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        onTap: () => _openAppointmentDetails(appointment, user),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    ),
                    child: Icon(
                      Icons.event_available,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(appointment.appointmentDate),
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Kezdés: ${appointment.startTime}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  _buildAppointmentMetaChip(
                    icon: Icons.spa,
                    label: 'Szolgáltatás',
                    value: serviceName,
                  ),
                  _buildAppointmentMetaChip(
                    icon: Icons.schedule,
                    label: 'Időtartam',
                    value: '${appointment.requestedDurationMinutes} perc',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(appointment.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLargeButton),
                  ),
                  child: Text(
                    _statusLabel(appointment.status),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: _statusColor(appointment.status),
                    ),
                  ),
                ),
              ),
              if (appointment.note?.trim().isNotEmpty == true) ...[
                const SizedBox(height: AppSpacing.m),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    appointment.note!.trim(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentMetaChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneSection(app_user.User user) {
    return _buildSectionCard(
      title: 'Biztonság',
      subtitle: 'A fiók törlése végleges művelet.',
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.warning_amber,
            title: 'Fiók végleges törlése',
            subtitle: 'Auth és Firestore profil törlésével együtt',
            iconColor: AppColors.error,
            onTap: () => _deleteAccount(user),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
    Widget? action,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.heading3,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (action != null) action,
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.labelLarge,
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMedium,
      ),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.labelLarge,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.labelLarge,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
