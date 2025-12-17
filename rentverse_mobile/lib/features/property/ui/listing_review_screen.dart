import 'package:flutter/material.dart';

class ListingReviewScreen extends StatelessWidget {
  const ListingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TEMP dummy data
    final listings = [
      {
        'title': 'Modern Apartment KL',
        'owner': 'John Doe',
        'status': 'PENDING'
      },
      {
        'title': 'Studio Near MRT',
        'owner': 'Aisyah',
        'status': 'PENDING'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Listing Reviews')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final item = listings[index];

          return Card(
            child: ListTile(
              title: Text(item['title']!),
              subtitle: Text('Owner: ${item['owner']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      // TODO: approve API
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      // TODO: reject API
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}