

import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/property.dart';

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;

  final ApiService _apiService = ApiService();
  // FIX: Removed 'const' keyword from the constructor
  PropertyDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Property Details')),
      // FIX: FutureBuilder correctly uses Property type
      body: FutureBuilder<Property>(
        future: _apiService.getPropertyDetails(propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'Error loading property details: ${snapshot.error.toString()}'),
            ));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Property not found.'));
          }

          final property = snapshot.data!;
          // ... rest of the UI (same as before)
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Text('Image of: ${property.title}',
                      style: TextStyle(color: Colors.blueGrey[700])),
                ),
                const SizedBox(height: 20),
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(property.location,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16)),
                    const Spacer(),
                    Text(
                      'RM ${property.price.toStringAsFixed(2)} / month',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18),
                    ),
                  ],
                ),
                const Divider(height: 30),
                _buildVerificationRow(property),
                const Divider(height: 30),
                Text(
                  'Details and Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                    'ID: ${property.id}. This property has been rated ${property.score.toStringAsFixed(1)} and is located in a prime area.'),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationRow(Property property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
                property.isVerified ? Icons.verified_user : Icons.warning_amber,
                color: property.isVerified ? Colors.green : Colors.orange),
            const SizedBox(width: 8),
            Text(property.isVerified
                ? 'Verified Listing'
                : 'Verification Pending'),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 4),
            Text(property.score.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}