import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Esperar 2 segundos y navegar a LoginPage
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 206, 206),
      body: const Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
