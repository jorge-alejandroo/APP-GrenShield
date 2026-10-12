import 'dart:async';

import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO DE M.A.M.B.O.
                  Image.asset(
                    'assets/images/logo_mambo.png',
                    width: 230,
                  ),

                  const SizedBox(height: 35),

                  // NOMBRE DE LA APLICACIÓN
                  const Text(
                    'GreenShield',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF145A32),
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DESCRIPCIÓN
                  const Text(
                    'Sistema de Monitoreo Ambiental',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // INDICADOR DE CARGA
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Cargando...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // EMPRESA DESARROLLADORA
                  const Text(
                    'Desarrollado por',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'M.A.M.B.O.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF145A32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}