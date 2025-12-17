// lib/features/properties/ui/upload_property_screen.dart

import 'package:flutter/material.dart';
import '../../../enums/user_role.dart';
import '../../../services/api_service.dart';
import '../../../shared/widgets/secure_button.dart';

class UploadPropertyScreen extends StatefulWidget {
  const UploadPropertyScreen({super.key});

  @override
  State<UploadPropertyScreen> createState() => _UploadPropertyScreenState();
}

class _UploadPropertyScreenState extends State<UploadPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitProperty() async {
    // 1. INPUT VALIDATION CHECK: Validate all fields using the form key
    if (!_formKey.currentState!.validate()) {
      // If validation fails, the TextFormField validator messages are shown.
      return;
    }

    setState(() => _isUploading = true);

    // 2. CONSTRUCT PAYLOAD: Ensure data types are correct for the API
    final propertyData = {
      'title': _titleController.text.trim(),
      'location': _locationController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'imageUrl':
          'https://rentverse.com/uploads/mock_default.jpg', // Placeholder for image upload
      'isVerified': false,
      'score': 0.0,
      // NOTE: In a real app, Owner ID would be added here via UserProvider
    };

    try {
      // 3. API CALL: Execute POST request
      await _apiService.uploadProperty(propertyData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Property uploaded successfully! Pending verification.')),
        );
        // 4. POST-SUBMISSION: Clear fields and navigate back
        _titleController.clear();
        _locationController.clear();
        _priceController.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        // 5. ERROR HANDLING: Display detailed error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Upload failed. Check server/permissions. Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload New Property')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Access Control: This action is restricted to Owners and Admins to maintain platform integrity.',
                style: TextStyle(
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                    fontSize: 14),
              ),
              const SizedBox(height: 20),

              // --- Title Field ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title is required.'
                    : null,
              ),
              const SizedBox(height: 15),

              // --- Location Field ---
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (City, State)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Location is required.'
                    : null,
              ),
              const SizedBox(height: 15),

              // --- Price Field ---
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rental Price (RM)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Price is required.';
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0)
                    return 'Enter a valid price greater than 0.';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // --- SECURE SUBMISSION BUTTON (Role-Based Access Control) ---
              // Only activated if the user's role is Owner or Admin
              SecureButton(
                onPressed: _submitProperty,
                label: _isUploading
                    ? 'Uploading Property...'
                    : 'Submit Property for Verification',
                requiredRoles: const [UserRole.Owner, UserRole.Admin],
                isEnabled:
                    !_isUploading, // Disable button if upload is in progress
              ),
              const SizedBox(height: 10),
              const Text(
                'The SecureButton widget enforces the Role Check before allowing the API call.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}