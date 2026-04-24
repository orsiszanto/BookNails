import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/cubit/appointment_cubit.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/service_cubit.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/empty_error_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Időpontfoglalás képernyő
class BookingScreen extends StatefulWidget {
  final String? serviceId;

  const BookingScreen({super.key, this.serviceId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _noteController = TextEditingController();
  final List<TimeOfDay> _availableSlots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 30),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 30),
  ];

  @override
  void initState() {
    super.initState();
    final serviceId = widget.serviceId;
    if (serviceId != null && serviceId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<ServiceCubit>().fetchService(serviceId);
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSelectDate() async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = now.add(const Duration(days: 30));

    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleBooking() {
    if (widget.serviceId == null || widget.serviceId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Először válasszon egy szolgáltatást')),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kérjük válasszon időpontot')),
      );
      return;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _submitBooking(
    ServiceDetailLoaded state,
  ) async {
    final service = state.service;
    final currentUser = context.read<AuthCubit>().getCurrentUser();

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bejelentkezés szükséges a foglaláshoz')),
      );
      return;
    }

    if (service.nailArtistProfileId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A szolgáltatáshoz nem tartozik körmös profil')),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      _handleBooking();
      return;
    }

    await context.read<AppointmentCubit>().createAppointment(
          userId: currentUser.uid,
          nailArtistProfileId: service.nailArtistProfileId,
          serviceId: service.id,
          appointmentDate: _selectedDate!,
          startTime: _formatTimeOfDay(_selectedTime!),
          requestedDurationMinutes: service.durationMinutes,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Foglalás'),
        elevation: 0,
      ),
      safeArea: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentCubit, AppointmentState>(
            listener: (context, appointmentState) {
              if (appointmentState is AppointmentCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foglalás sikeresen elmentve')),
                );
              } else if (appointmentState is AppointmentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(appointmentState.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
          if (widget.serviceId == null || widget.serviceId!.isEmpty) {
            return EmptyState(
              icon: Icons.spa,
              title: 'Nincs kiválasztott szolgáltatás',
              description:
                  'Válasszon egy szolgáltatást a szolgáltatások oldaláról, és itt automatikusan megjelennek az adatai.',
              action: ElevatedButton(
                onPressed: () => context.goNamed('services'),
                child: const Text('Vissza a szolgáltatásokhoz'),
              ),
            );
          }

          if (state is ServiceLoading || state is ServiceInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ServiceError) {
            return EmptyState(
              icon: Icons.error_outline,
              title: 'Hiba a szolgáltatás betöltésekor',
              description: state.message,
              action: ElevatedButton(
                onPressed: () => context.read<ServiceCubit>().fetchService(widget.serviceId!),
                child: const Text('Újra próbálkozás'),
              ),
            );
          }

          if (state is! ServiceDetailLoaded) {
            return const SizedBox.shrink();
          }

          final service = state.service;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kiválasztott szolgáltatás',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: AppTextStyles.heading3,
                                  ),
                                  const SizedBox(height: AppSpacing.s),
                                  Text(
                                    'Időtartam: ${service.durationMinutes} perc',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Text(
                              '${service.price.toStringAsFixed(0)} Ft',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                const Text(
                  'Dátum kiválasztása',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSpacing.m),
                ElevatedButton.icon(
                  onPressed: _handleSelectDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate == null
                        ? 'Válasszon dátumot'
                        : '${_selectedDate!.year}. ${_selectedDate!.month}. ${_selectedDate!.day}.',
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                if (_selectedDate != null) ...[
                  const Text(
                    'Szabad időpontok',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.s,
                    children: _availableSlots.map((slot) {
                      final isSelected = _selectedTime == slot;
                      return ChoiceChip(
                        label: Text(
                          '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}',
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedTime = selected ? slot : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
                AppTextField(
                  label: 'Megjegyzés',
                  hint: 'Bármilyen további információ...',
                  controller: _noteController,
                  maxLines: 3,
                  maxLength: 250,
                ),
                const SizedBox(height: AppSpacing.l),
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, appointmentState) {
                    final isSubmitting = appointmentState is AppointmentLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isSubmitting
                            ? null
                            : () => _submitBooking(state),
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          isSubmitting
                              ? 'Mentés...'
                              : 'Foglalás megerősítése',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}
