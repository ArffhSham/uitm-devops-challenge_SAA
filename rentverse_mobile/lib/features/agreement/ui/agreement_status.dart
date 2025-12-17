import 'package:flutter/material.dart';
import '../data/agreement_models.dart';
import 'agreement_sign_screen.dart';

class AgreementStatusScreen extends StatelessWidget {
  const AgreementStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This screen typically fetches the status from the API. Mocking final signed status.
    const mockStatus = AgreementStatus.SIGNED;

    return Scaffold(
      appBar: AppBar(title: const Text('Agreement Status Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mockStatus == AgreementStatus.SIGNED
                  ? Icons.check_circle_outline
                  : Icons.pending_actions,
              size: 80,
              color: mockStatus == AgreementStatus.SIGNED
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              'Agreement Status: ${mockStatus.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your digital agreement has been successfully signed and validated.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Mock link to the signing screen for demonstration
                Navigator.of(
                  context,
                ).pushNamed(AgreementSignScreen.routeName, arguments: 'AGR123');
              },
              child: const Text('View Signed Document'),
            ),
          ],
        ),
      ),
    );
  }
}