import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../models/agreement_details.dart';
// Import your service here (assuming it's in your services folder)
// import '../../../services/agreement_service.dart';

class AgreementSignScreen extends StatefulWidget {
  static const routeName = '/agreement-sign';

  const AgreementSignScreen({super.key});

  @override
  State<AgreementSignScreen> createState() => _AgreementSignScreenState();
}

class _AgreementSignScreenState extends State<AgreementSignScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isSaving = false; // New state to handle the database save process

  // This is the data being prepared for the database
  final AgreementDetails _details = AgreementDetails.fromJson({
    'id': 'AGR-E40F18',
    'landlordName': 'John Smith',
    'tenantName': 'Jane Doe',
    'amount': '1,200.00',
    'currency': 'MYR'
  });

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
            onPageFinished: (_) => setState(() => _isLoading = false)),
      )
      ..loadHtmlString(_details.documentText);
  }

  // NEW: Logic to add the agreement to the database table
  Future<void> _handleSignAndSave() async {
    setState(() => _isSaving = true);

    try {
      // 1. Call your service to save the agreement data
      // Replace with your actual service call:
      // bool success = await AgreementService().addToAgreementTable(_details);

      // Simulating a network delay for the database save
      await Future.delayed(const Duration(seconds: 2));
      bool success = true; // Assume success for this example

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Agreement successfully saved to database!')),
        );
        // Navigate away or close screen after success
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving to database: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review & Sign')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: WebViewWidget(controller: _controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  // UPDATED: Now calls the sign and save logic
                  onPressed: _isSaving ? null : _handleSignAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("CONFIRM & SIGN DIGITALLY",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}