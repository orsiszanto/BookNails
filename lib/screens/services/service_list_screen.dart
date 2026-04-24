import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/cubit/service_cubit.dart';
import '../../models/service.dart';
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
  String _sortBy = 'name'; // name or price
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch all active services from Firebase when screen loads
    // Simple query without complex filtering/sorting to avoid index requirements
    context.read<ServiceCubit>().fetchServicesByFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleServiceTap(Service service) {
    context.pushNamed(
      'booking',
      pathParameters: {'serviceId': service.id},
    );
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
              onChanged: (_) => setState(() {}),
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
             child: BlocBuilder<ServiceCubit, ServiceState>(
               builder: (context, state) {
                 if (state is ServiceLoading) {
                   return const LoadingIndicator(
                     isLoading: true,
                     child: SizedBox.shrink(),
                   );
                 } else if (state is ServiceLoaded) {
                   return _buildServicesList(state.services);
                 } else if (state is ServiceError) {
                   return Center(
                     child: EmptyState(
                       icon: Icons.error_outline,
                       title: 'Hiba',
                       description: state.message,
                       action: ElevatedButton(
                         onPressed: () =>
                             context.read<ServiceCubit>().fetchServicesByFilters(),
                         child: const Text('Újra próbálkozás'),
                       ),
                     ),
                   );
                 }
                 return const SizedBox.shrink();
               },
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<Service> services) {
    // Filter services based on search
    final filteredServices = services
        .where((service) => service.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    // Sort services
    if (_sortBy == 'price') {
      filteredServices.sort((a, b) => a.price.compareTo(b.price));
    } else {
      filteredServices.sort((a, b) => a.name.compareTo(b.name));
    }

    if (filteredServices.isEmpty) {
      return EmptyState(
        icon: Icons.spa,
        title: 'Nincs találat',
        description: 'Sajnos nincs olyan szolgáltatás, amit keresne.',
        action: ElevatedButton(
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
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
          title: service.name,
          description: service.description,
          price: '${service.price.toStringAsFixed(0)} Ft',
          duration: '${service.durationMinutes} perc',
          onTap: () => _handleServiceTap(service),
        );
      },
    );
  }
}
