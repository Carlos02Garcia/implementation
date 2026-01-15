import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: ThemeData(

        
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Esperar 3 segundos y navegar a LoginPage
    Future.delayed(const Duration(seconds: 2), () {
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Colors chosen to match the screenshot
    final background = const Color(0xFFF4CFCF); // soft pink
    final red = const Color(0xFFE53935);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // Logo inside rounded rect with blue border
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 240,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 28),

                // Welcome pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'BIENVENIDO A TU APP\nMECANICA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Nombre',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      // Placeholder action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Usuario: $username')),
                      );
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                // Optional small indicator or spacing
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


