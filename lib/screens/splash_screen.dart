// import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:hydrofarm/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // Logo tampil selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Mulai menghilangkan logo
    setState(() {
      _opacity = 0.0;
    });

    // Tunggu proses fade out
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Nanti diarahkan ke LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Image.asset('assets/logo.png', width: 220),
        ),
      ),
    );
  }
}
