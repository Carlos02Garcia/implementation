import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, this.vehicle, this.problem});

  final String? vehicle;
  final String? problem;

  bool get _hasRequestInfo => vehicle != null && problem != null;

  @override
  Widget build(BuildContext context) {
    final Color accent = const Color(0xFFE53935);
    final String title = _hasRequestInfo ? 'Solicitud enviada' : 'Acceso concedido';
    final String detail = _hasRequestInfo
        ? 'Hemos recibido tu solicitud: $problem para tu $vehicle.'
        : 'OTP verificado correctamente';

    return Scaffold(
      backgroundColor: const Color(0xFFF4CFCF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.check_circle_outline,
                size: 120,
                color: accent,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Volver al inicio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
