// lib/features/properties/ui/property_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../enums/user_role.dart';
import '../../../services/api_service.dart';
import '../../../services/user_provider.dart';
import '../../../models/property.dart';
import '../../../shared/widgets/property_card.dart';
import '../../../shared/widgets/secure_button.dart';
import '../../agreement/ui/agreement_sign_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Property>> _propertiesFuture;
  bool _isInit = true; // Flag to ensure we only initialize once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // 1. Extract the search arguments passed from HomePage
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      // 2. Call the updated fetch method with filters
      _propertiesFuture = _apiService.fetchProperties(
        location: args?['location'],
        type: args?['type'],
        priceRange: args?['priceRange'],
      );

      _isInit = false;
    }
  }

  void _requestRental(BuildContext context, String propertyId) async {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;

    try {
      final result = await _apiService.requestRental(
        propertyId: propertyId,
        tenantId: user.id,
      );

      if (!mounted) return;

      final agreementId = result['agreementId']!; // Successfully retrieved ID

      // Navigate using the route name and pass the ID as arguments
      Navigator.of(context).pushNamed(
        AgreementSignScreen.routeName,
        arguments: agreementId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Featured Properties')),
      // FIX: FutureBuilder correctly uses List<Property> type
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading properties: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No featured properties found.'));
          }

          final properties = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Column(
                children: [
                  PropertyCard(
                    property: property,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/property-detail',
                        arguments: property.id,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: SecureButton(
                      onPressed: () => _requestRental(context, property.id),
                      label: 'Request Rental Agreement',
                      requiredRoles: const [UserRole.Tenant],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}