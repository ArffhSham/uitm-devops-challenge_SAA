import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/auth_provider.dart';
import 'otp_screen.dart';
import '../../../core/utils/validators.dart';

// Define the primary blue color for the theme
const Color kPrimaryBlue = Color(0xFF1976D2); // A standard Material Blue

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      // Subtle background for the modern look
      backgroundColor: Colors.blue.shade50,
      // Removed AppBar to put title inside the body
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Title/Logo area
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlue,
                ),
              ),
              const SizedBox(height: 30),

              // 2. Central Card Container
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Secure Login',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 24),

                        // --- Original Email Input (Themed) ---
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: kPrimaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // --- Original Password Input (Themed) ---
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: kPrimaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
                            ),
                          ),
                          obscureText: true,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 32),

                        // --- Original Button Logic Preserved ---
                        authState.isLoading
                            ? const CircularProgressIndicator(color: kPrimaryBlue)
                            : SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // 🚀 LOGIC PRESERVED HERE 🚀
                                    if (_formKey.currentState!.validate()) {
                                      // Login (tempToken is stored inside provider)
                                      await ref.read(authProvider.notifier).login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );

                                      final state = ref.read(authProvider);

                                      if (state.error != null) {
                                        // Login failed
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(state.error!),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                        return; // Do NOT navigate if login failed
                                      }

                                      if (state.isLoading) return; // safety check

                                      // Show success message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Login successful!'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      // Navigate to OTP screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const OtpScreen(),
                                        ),
                                      );
                                    }
                                    // 🚀 LOGIC PRESERVED HERE 🚀
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryBlue, // Blue theme color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 5,
                                  ),
                                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}