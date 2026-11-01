import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HydroFarmApp());
}

class HydroFarmApp extends StatelessWidget {
  const HydroFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HydroFarm',
      home: const SplashScreen(),
    );
  }
}
