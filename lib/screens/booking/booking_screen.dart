import 'package:flutter/material.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Időpontfoglalás képernyő
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _noteController = TextEditingController();

  // Mock data
  final String _serviceName = 'Géllakk';
  final String _price = '5 000 Ft';
  final String _duration = '90 perc';
  final List<TimeOfDay> _availableSlots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 30),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 30),
  ];

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
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kérjük válasszon időpontot')),
      );
      return;
    }

    // TODO: Submit booking via Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foglalás beküldve')),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Szolgáltatás összefoglalás
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _serviceName,
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Text(
                              'Időtartam: $_duration',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        Text(
                          _price,
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
            // Dátum kiválasztás
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
            // Időpont kiválasztás
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
            // Megjegyzés
            AppTextField(
              label: 'Megjegyzés',
              hint: 'Bármilyen további információ...',
              controller: _noteController,
              maxLines: 3,
              maxLength: 250,
            ),
            const SizedBox(height: AppSpacing.l),
            // Foglalás gomb
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleBooking,
                icon: const Icon(Icons.check),
                label: const Text('Foglalás megerősítése'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
