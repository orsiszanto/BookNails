import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../bloc/cubit/appointment_cubit.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/nail_artist_profile_cubit.dart';
import '../../bloc/cubit/service_cubit.dart';
import '../../models/appointment.dart';
import '../../models/nail_artist_profile.dart';
import '../../models/service.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/empty_error_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

enum AdminManagementSection { profile, services, appointments }

extension AdminManagementSectionX on AdminManagementSection {
  String get routeValue => switch (this) {
        AdminManagementSection.profile => 'profile',
        AdminManagementSection.services => 'services',
        AdminManagementSection.appointments => 'appointments',
      };

  String get title => switch (this) {
        AdminManagementSection.profile => 'Nail artist profil kezelése',
        AdminManagementSection.services => 'Szolgáltatások kezelése',
        AdminManagementSection.appointments => 'Időpontfoglalások kezelése',
      };

  String get subtitle => switch (this) {
        AdminManagementSection.profile =>
          'Kezeld a szalonprofilokat, elérhetőségeket és a kapcsolódó adatokat.',
        AdminManagementSection.services =>
          'Szerkeszd a szolgáltatásokat, árakat, időtartamokat és az aktív állapotot.',
        AdminManagementSection.appointments =>
          'Tekintsd át a foglalásokat, és módosítsd azok státuszát vagy töröld őket.',
      };

  static AdminManagementSection? fromRouteValue(String? value) {
    switch (value) {
      case 'profile':
        return AdminManagementSection.profile;
      case 'services':
        return AdminManagementSection.services;
      case 'appointments':
        return AdminManagementSection.appointments;
      default:
        return null;
    }
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthCubit>().signOut();
    if (!context.mounted) return;
    context.goNamed('login');
  }

  void _openSection(BuildContext context, AdminManagementSection section) {
    context.pushNamed(
      'admin-management',
      pathParameters: {'section': section.routeValue},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Kijelentkezés',
          ),
        ],
      ),
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.dashboard, color: Colors.white, size: 40),
                SizedBox(height: AppSpacing.m),
                Text(
                  'Admin felület',
                  style: AppTextStyles.heading2,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Válassz egy kezelőmodult az adminisztrációhoz.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          _DashboardActionCard(
            icon: Icons.badge,
            title: 'Nail artist profil kezelése',
            subtitle: 'Profilok, elérhetőségek és szalonadatok',
            onPressed: () => _openSection(context, AdminManagementSection.profile),
          ),
          const SizedBox(height: AppSpacing.m),
          _DashboardActionCard(
            icon: Icons.spa,
            title: 'Szolgáltatások kezelése',
            subtitle: 'Szolgáltatások listája, adatai és aktív állapota',
            onPressed: () => _openSection(context, AdminManagementSection.services),
          ),
          const SizedBox(height: AppSpacing.m),
          _DashboardActionCard(
            icon: Icons.calendar_month,
            title: 'Időpontfoglalások kezelése',
            subtitle: 'Foglalások státusza, részletei és törlése',
            onPressed: () => _openSection(context, AdminManagementSection.appointments),
          ),
        ],
      ),
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _DashboardActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminManagementScreen extends StatefulWidget {
  final AdminManagementSection section;

  const AdminManagementScreen({super.key, required this.section});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    switch (widget.section) {
      case AdminManagementSection.profile:
        await context.read<NailArtistProfileCubit>().fetchNailArtistProfiles();
        break;
      case AdminManagementSection.services:
        await context.read<ServiceCubit>().fetchServices();
        break;
      case AdminManagementSection.appointments:
        await context.read<AppointmentCubit>().fetchAppointments();
        break;
    }
  }

  Future<void> _handleLogout() async {
    await context.read<AuthCubit>().signOut();
    if (!mounted) return;
    context.goNamed('login');
  }

  Future<void> _handleRefresh() => _loadData();

  String _formatDateTime(DateTime value) {
    return DateFormat('yyyy.MM.dd. HH:mm').format(value);
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
      case 'cancel_requested':
        return AppColors.info;
      case 'cancelled':
        return AppColors.textSecondary;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _editProfile(NailArtistProfile profile) async {
    final salonController = TextEditingController(text: profile.salonName);
    final addressController = TextEditingController(text: profile.address);
    final phoneController = TextEditingController(text: profile.phoneNumber);
    final imageController = TextEditingController(text: profile.profileImageUrl ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Profil szerkesztése'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: salonController, decoration: const InputDecoration(labelText: 'Szalon neve')),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Cím')),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Telefonszám')),
                TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Profilkép URL (opcionális)')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<NailArtistProfileCubit>().updateNailArtistProfile(
                      profileId: profile.id,
                      salonName: salonController.text.trim(),
                      address: addressController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      profileImageUrl: imageController.text.trim().isEmpty ? null : imageController.text.trim(),
                    );
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Mentés'),
            ),
          ],
        );
      },
    );

    salonController.dispose();
    addressController.dispose();
    phoneController.dispose();
    imageController.dispose();

    if (saved == true && mounted) {
      await _handleRefresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil frissítve')));
    }
  }

  Future<void> _deleteProfile(NailArtistProfile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Profil törlése'),
          content: Text('Biztosan törlöd ezt a profilt: ${profile.salonName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Törlés'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await context.read<NailArtistProfileCubit>().deleteNailArtistProfile(profile.id);
      await _handleRefresh();
    }
  }

  Future<void> _editService(Service service) async {
    final nameController = TextEditingController(text: service.name);
    final descriptionController = TextEditingController(text: service.description);
    final priceController = TextEditingController(text: service.price.toStringAsFixed(0));
    final durationController = TextEditingController(text: service.durationMinutes.toString());
    bool isActive = service.isActive;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Szolgáltatás szerkesztése'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Név')),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Leírás'), maxLines: 3),
                    TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Ár (Ft)'), keyboardType: TextInputType.number),
                    TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Időtartam (perc)'), keyboardType: TextInputType.number),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Aktív'),
                      value: isActive,
                      onChanged: (value) => setStateDialog(() => isActive = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Mégse'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<ServiceCubit>().updateService(
                          serviceId: service.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          price: double.tryParse(priceController.text.replaceAll(',', '.').trim()) ?? service.price,
                          durationMinutes: int.tryParse(durationController.text.trim()) ?? service.durationMinutes,
                          isActive: isActive,
                        );
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text('Mentés'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    durationController.dispose();

    if (saved == true && mounted) {
      await _handleRefresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Szolgáltatás frissítve')));
    }
  }

  Future<void> _deleteService(Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Szolgáltatás törlése'),
          content: Text('Biztosan törlöd ezt a szolgáltatást: ${service.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Törlés'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await context.read<ServiceCubit>().deleteService(service.id);
      await _handleRefresh();
    }
  }

  Future<void> _editAppointment(Appointment appointment) async {
    final estimatedDurationController = TextEditingController(
      text: appointment.estimatedDurationMinutes?.toString() ?? '',
    );
    final noteController = TextEditingController(text: appointment.note ?? '');
    String status = appointment.status;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Foglalás szerkesztése'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: status,
                      items: const [
                        DropdownMenuItem(value: 'pending', child: Text('Függőben')),
                        DropdownMenuItem(value: 'confirmed', child: Text('Jóváhagyva')),
                        DropdownMenuItem(value: 'modification_requested', child: Text('Módosítást kér')),
                        DropdownMenuItem(value: 'cancel_requested', child: Text('Lemondást kér')),
                        DropdownMenuItem(value: 'cancelled', child: Text('Lemondva')),
                        DropdownMenuItem(value: 'rejected', child: Text('Elutasítva')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setStateDialog(() => status = value);
                      },
                      decoration: const InputDecoration(labelText: 'Státusz'),
                    ),
                    TextField(
                      controller: estimatedDurationController,
                      decoration: const InputDecoration(labelText: 'Becsült időtartam (perc)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Megjegyzés'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Mégse'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<AppointmentCubit>().updateAppointment(
                          appointmentId: appointment.id,
                          estimatedDurationMinutes: int.tryParse(estimatedDurationController.text.trim()),
                          note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                          status: status,
                        );
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text('Mentés'),
                ),
              ],
            );
          },
        );
      },
    );

    estimatedDurationController.dispose();
    noteController.dispose();

    if (saved == true && mounted) {
      await _handleRefresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foglalás frissítve')));
    }
  }

  Future<void> _deleteAppointment(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Foglalás törlése'),
          content: Text('Biztosan törlöd ezt a foglalást: ${_formatDateTime(appointment.appointmentDate)}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Mégse'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Törlés'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await context.read<AppointmentCubit>().deleteAppointment(appointment.id);
      await _handleRefresh();
    }
  }

  Widget _buildProfileBody() {
    return BlocBuilder<NailArtistProfileCubit, NailArtistProfileState>(
      builder: (context, state) {
        if (state is NailArtistProfileLoading || state is NailArtistProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NailArtistProfileError) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Nem sikerült betölteni a profilokat',
            description: state.message,
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Újrapróbálás'),
            ),
          );
        }

        final profiles = state is NailArtistProfileLoaded ? state.profiles : const <NailArtistProfile>[];
        if (profiles.isEmpty) {
          return EmptyState(
            icon: Icons.badge_outlined,
            title: 'Nincsenek profilok',
            description: 'Jelenleg nincs megjeleníthető nail artist profil.',
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Frissítés'),
            ),
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          itemCount: profiles.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return Card(
              child: ListTile(
                title: Text(profile.salonName),
                subtitle: Text(
                  '${profile.address}\n${profile.phoneNumber}\nUID: ${profile.userId}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Szerkesztés',
                      onPressed: () => _editProfile(profile),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Törlés',
                      onPressed: () => _deleteProfile(profile),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServicesBody() {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading || state is ServiceInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ServiceError) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Nem sikerült betölteni a szolgáltatásokat',
            description: state.message,
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Újrapróbálás'),
            ),
          );
        }

        final services = state is ServiceLoaded ? state.services : const <Service>[];
        if (services.isEmpty) {
          return EmptyState(
            icon: Icons.spa_outlined,
            title: 'Nincsenek szolgáltatások',
            description: 'Jelenleg nincs megjeleníthető szolgáltatás.',
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Frissítés'),
            ),
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          itemCount: services.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              child: ListTile(
                title: Text(service.name),
                subtitle: Text(
                  '${service.description}\n${service.price.toStringAsFixed(0)} Ft • ${service.durationMinutes} perc\nAktív: ${service.isActive ? 'Igen' : 'Nem'}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Szerkesztés',
                      onPressed: () => _editService(service),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Törlés',
                      onPressed: () => _deleteService(service),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAppointmentsBody() {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading || state is AppointmentInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentError) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Nem sikerült betölteni a foglalásokat',
            description: state.message,
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Újrapróbálás'),
            ),
          );
        }

        final appointments = state is AppointmentLoaded ? state.appointments : const <Appointment>[];
        if (appointments.isEmpty) {
          return EmptyState(
            icon: Icons.calendar_month_outlined,
            title: 'Nincsenek foglalások',
            description: 'Jelenleg nincs megjeleníthető időpontfoglalás.',
            action: ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Frissítés'),
            ),
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              child: ListTile(
                title: Text(_formatDateTime(appointment.appointmentDate)),
                subtitle: Text(
                  'Kezdés: ${appointment.startTime}\nÁllapot: ${_statusLabel(appointment.status)}\nSzolgáltatás: ${appointment.serviceId}\nKörmös profil: ${appointment.nailArtistProfileId}',
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Szerkesztés',
                      onPressed: () => _editAppointment(appointment),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Törlés',
                      onPressed: () => _deleteAppointment(appointment),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.section.title),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Frissítés',
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Kijelentkezés',
          ),
        ],
      ),
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.section.subtitle, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.m),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: switch (widget.section) {
                AdminManagementSection.profile => _buildProfileBody(),
                AdminManagementSection.services => _buildServicesBody(),
                AdminManagementSection.appointments => _buildAppointmentsBody(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

