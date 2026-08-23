import 'dart:async';
import 'package:flutter/material.dart';
import 'package:implementation/auth_service.dart';
import 'vehicle_selection_page.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    super.key,
    required this.email,
    required this.baseUrl,
  });

  final String email;
  final String baseUrl;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  int _seconds = 60; // 1:00
  Timer? _timer;
  bool _isVerifying = false;
  bool _isResending = false;

  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(baseUrl: widget.baseUrl);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  String get _timeFormatted {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return 'tu correo';
    final local = parts[0];
    final domain = parts[1];
    if (local.isEmpty) return '***@$domain';
    if (local.length == 1) return '$local***@$domain';
    final first = local.substring(0, 1);
    final last = local.substring(local.length - 1);
    return '$first***$last@$domain';
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF4CFCF);
    const red = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Codigo de verificacion',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Te enviamos el codigo a $_maskedEmail',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 30),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _otpBox(i)),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Resend OTP in $_timeFormatted'),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: (_seconds == 0 && !_isResending)
                        ? _resendCode
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isResending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Resend OTP',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  onPressed: _isVerifying ? null : _verifyCode,
                  child: _isVerifying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();

    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese el código completo')),
      );
      return;
    }

    setState(() => _isVerifying = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final resp = await _authService
          .verifyOtp(widget.email, code)
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (resp.statusCode == 200) {
        messenger.showSnackBar(
          const SnackBar(content: Text('OTP verificado')),
        );
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const VehicleSelectionPage()),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${resp.statusCode} - ${resp.body}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final resp = await _authService
          .resendOtp(widget.email)
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (resp.statusCode == 200) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Nuevo código enviado')),
        );
        _startTimer();
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${resp.statusCode} - ${resp.body}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
}
