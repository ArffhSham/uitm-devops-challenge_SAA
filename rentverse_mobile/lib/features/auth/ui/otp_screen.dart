import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/auth_provider.dart';
import 'role_router.dart';

// Primary theme color
const Color kPrimaryBlue = Color(0xFF1976D2);

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool otpSent = false;
  bool _isVerifying = false;

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  // ==========================
  // VERIFY OTP
  // ==========================
  Future<void> _verifyOtp() async {
    if (_isVerifying) return;

    final otp = _otpController.text.trim();
    if (otp.length != 6) return;

    _isVerifying = true;
    FocusScope.of(context).unfocus();

    await ref.read(authProvider.notifier).verifyOtp(otp);
    final state = ref.read(authProvider);

    _isVerifying = false;

    if (state.role != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP verified successfully'),
          backgroundColor: Colors.green,
        ),
      );

      _timer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RoleRouter(role: state.role!),
        ),
      );
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================
  // RESEND COUNTDOWN
  // ==========================
  void _startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ==========================
                  // PHONE NUMBER
                  // ==========================
                  if (!otpSent) ...[
                    const Text(
                      'Enter Phone Number',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: kPrimaryBlue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    authState.isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue,
                              ),
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String phone =
                                      _phoneController.text.trim();

                                  if (!phone.startsWith('+')) {
                                    phone = '+60$phone';
                                  }

                                  ref
                                      .read(authProvider.notifier)
                                      .setPhone(phone);

                                  await ref
                                      .read(authProvider.notifier)
                                      .requestOtp();

                                  final state =
                                      ref.read(authProvider);

                                  if (state.error != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(state.error!),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      otpSent = true;
                                    });
                                    _startCountdown();
                                  }
                                }
                              },
                            ),
                          ),
                  ],

                  // ==========================
                  // OTP INPUT
                  // ==========================
                  if (otpSent) ...[
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryBlue,
                        ),
                        onPressed: !_isVerifying
                            ? _verifyOtp
                            : null,
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: _canResend
                          ? () async {
                              await ref
                                  .read(authProvider.notifier)
                                  .requestOtp();
                              _startCountdown();
                            }
                          : null,
                      child: Text(
                        _canResend
                            ? 'Resend OTP'
                            : 'Resend in $_secondsRemaining s',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  // CLEANUP
  // ==========================
  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
