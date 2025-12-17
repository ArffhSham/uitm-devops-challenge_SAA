// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Needed for kDebugMode

import '../enums/user_role.dart';
import '../models/property.dart';
import '../models/activity.dart';
import '../models/agreement_details.dart';
import '../models/user.dart';

class ApiService {
  // ⚠️ ACTION REQUIRED: Update this IP to your actual server IP address.
  static const String _baseUrl = 'http://10.0.2.2:3000';

  // --- API HELPER METHODS ---

  Future<dynamic> _fetchData(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load $endpoint. Status: ${response.statusCode}');
    }
  }

  Future<dynamic> _postData(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    // NOTE: In a real app, you would add headers with the JWT token here.
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } else {
      String errorMessage = 'Request failed to $endpoint.';
      try {
        final errorJson = jsonDecode(response.body);
        errorMessage = errorJson['message'] ?? errorMessage;
      } catch (_) {}
      throw Exception('$errorMessage Status: ${response.statusCode}');
    }
  }

  // --- AUTH METHODS (MEMBER 1) ---

  Future<User> login(String username, String password) async {
    // POST /api/auth/login
    final body = {
      'username': username,
      'password': password,
    };
    try {
      // Assuming a successful login returns a user object
      await _postData('auth/login', body); // Consume the API

      // MOCK: Since we don't have the live backend here, we mock the User response
      // that requires MFA after a successful call.
      if (username.toLowerCase().contains('admin')) return User.mockAdmin();
      if (username.toLowerCase().contains('owner')) return User.mockOwner();
      return User.mockTenant();
    } catch (e) {
      // If the API call fails, in debug mode, we still return a mock user
      if (kDebugMode) {
        if (username.toLowerCase().contains('admin')) return User.mockAdmin();
        if (username.toLowerCase().contains('owner')) return User.mockOwner();
        if (username.toLowerCase().contains('tenant')) return User.mockTenant();
      }
      rethrow;
    }
  }

  Future<bool> verifyMfaOtp(String userId, String otp) async {
    // POST /api/auth/verify-otp
    final body = {
      'userId': userId,
      'otp': otp,
    };
    try {
      final jsonResponse = await _postData('auth/verify-otp', body);
      return jsonResponse['success'] as bool? ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Activity>> fetchActivityLogs() async {
    // GET /api/logs/activity
    final jsonResponse = await _fetchData('logs/activity');
    return (jsonResponse as List)
        .map((data) => Activity.fromJson(data))
        .toList();
  }

  // --- MEMBER 1/2: Test Mocking ---

  /// [FOR TESTING] Simulates a login response based on the requested role.
  /// Used by login_screen.dart to bypass API calls in development.
  User mockLogin(UserRole role) {
    switch (role) {
      case UserRole.Admin:
        return User.mockAdmin();
      case UserRole.Owner:
        return User.mockOwner();
      case UserRole.Tenant:
        return User.mockTenant();
      default:
        return User.mockTenant(); // Default fallback
    }
  }

  // --- PROPERTY METHODS (MEMBER 2) ---

  // --- UPDATED METHOD ---
  Future<List<Property>> fetchProperties({
    String? location,
    String? type,
    String? priceRange,
  }) async {
    // Build the query parameters map
    final Map<String, String> queryParams = {};
    if (location != null && location.isNotEmpty)
      queryParams['location'] = location;
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (priceRange != null && priceRange != 'Any Price')
      queryParams['priceRange'] = priceRange;

    // Construct URI with query parameters: /properties?location=...&type=...
    final uri =
        Uri.parse('$_baseUrl/properties').replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((p) => Property.fromJson(p)).toList();
    } else {
      throw Exception(
          'Failed to load properties. Status: ${response.statusCode}');
    }
  }

  Future<List<Property>> fetchFeaturedProperties() async {
    final jsonResponse = await _fetchData('properties');
    return (jsonResponse as List).map((p) => Property.fromJson(p)).toList();
  }

  Future<Property> getPropertyDetails(String propertyId) async {
    final jsonResponse = await _fetchData('properties/$propertyId');
    return Property.fromJson(jsonResponse);
  }

  Future<void> uploadProperty(Map<String, dynamic> propertyData) async {
    // POST /api/properties/upload
    await _postData('properties/upload', propertyData);
  }

  // --- AGREEMENT/RENTAL METHODS (MEMBER 2) ---

  Future<AgreementDetails> fetchAgreementDetails(String agreementId) async {
    // GET /api/agreements/:agreementId
    final jsonResponse = await _fetchData('agreements/$agreementId');
    return AgreementDetails.fromJson(jsonResponse);
  }

  Future<Map<String, String>> requestRental({
    required String propertyId,
    required String tenantId,
  }) async {
    final body = {
      'propertyId': propertyId,
      'tenantId': tenantId,
    };
    // This calls POST /rentals/request defined above
    final jsonResponse = await _postData('rentals/request', body);

    return {
      'agreementId': jsonResponse['agreementId'] as String,
      'documentHash': jsonResponse['documentHash'] as String,
    };
  }

  Future<void> saveSignedAgreement(AgreementDetails agreement) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/agreements/sign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(agreement.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Agreement successfully saved to database.');
      } else {
        throw Exception('Failed to save agreement: ${response.body}');
      }
    } catch (e) {
      print('Error sending data to table: $e');
      rethrow;
    }
  }

  Future<void> signAgreement({
    required String agreementId,
    required String tenantSignature,
    required String documentHash,
  }) async {
    // POST /api/agreements/sign
    final body = {
      'agreementId': agreementId,
      'signature': tenantSignature,
      'documentHash': documentHash,
    };
    await _postData('agreements/sign', body);
  }
}

class AgreementService {
  final String apiUrl = "https://your-api.com/agreements";

  Future<bool> addToAgreementTable(AgreementDetails details) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(details.toJson()), // Uses the toJson from above
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Successfully added to table.");
        return true;
      } else {
        print("Database error: \${response.body}");
        return false;
      }
    } catch (e) {
      print("Network error: \$e");
      return false;
    }
  }
}