import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/service_grid_card.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/empty_error_state.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Szolgáltatások listájának képernyő
class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _searchController = TextEditingController();
  final bool _isLoading = false;
  String _sortBy = 'name'; // name or price

  // Mock data
  final List<Map<String, dynamic>> _mockServices = [
    {
      'id': '1',
      'title': 'Géllakk',
      'description': 'Professzionális géllakk manikűr',
      'price': '5 000 Ft',
      'duration': '90 perc',
    },
    {
      'id': '2',
      'title': 'Körmöshöz',
      'description': 'Természetes körmök ápolása',
      'price': '3 500 Ft',
      'duration': '60 perc',
    },
    {
      'id': '3',
      'title': 'Körömrák eltávolítás',
      'description': 'Körömrák szakszerű eltávolítása',
      'price': '2 000 Ft',
      'duration': '30 perc',
    },
    {
      'id': '4',
      'title': 'Pedicure',
      'description': 'Komplett lábápolás',
      'price': '4 500 Ft',
      'duration': '75 perc',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleServiceTap(String serviceId) {
    context.pushNamed('booking');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Szolgáltatások'),
        elevation: 0,
      ),
      safeArea: true,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: AppTextField(
              label: 'Keresés',
              hint: 'Keres szolgáltatást...',
              controller: _searchController,
              prefixIcon: Icons.search,
            ),
          ),
          // Sort dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rendezés:',
                  style: AppTextStyles.bodyMedium,
                  semanticsLabel: 'Rendezési opciók - Alszekció fejléc',
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Név szerint'),
                    ),
                    DropdownMenuItem(
                      value: 'price',
                      child: Text('Ár szerint'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _sortBy = value ?? 'name');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Services list
          Expanded(
            child: LoadingIndicator(
              isLoading: _isLoading,
              child: _buildServicesList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    final filteredServices = _mockServices
        .where((service) => service['title']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    if (filteredServices.isEmpty) {
      return EmptyState(
        icon: Icons.spa,
        title: 'Nincs találat',
        description: 'Sajnos nincs olyan szolgáltatás, amit keresne.',
        action: ElevatedButton(
          onPressed: () => _searchController.clear(),
          child: const Text('Keresés törlése'),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.m),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.55,
      ),
      itemCount: filteredServices.length,
      itemBuilder: (context, index) {
        final service = filteredServices[index];
        return ServiceGridCard(
          title: service['title'],
          description: service['description'],
          price: service['price'],
          duration: service['duration'],
          onTap: () => _handleServiceTap(service['id']),
        );
      },
    );
  }
}
