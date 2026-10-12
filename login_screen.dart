import 'package:flutter/material.dart';
import '../services/greenshield_api.dart';

import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'email_verification_screen.dart';
import 'user_home_screen.dart';
import 'admin_home_screen.dart'; // ⚠️ TEMPORAL: acceso admin

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _ocultarPassword = true;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final correo = _usuarioController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      setState(() => _error = 'Por favor, completa todos los campos.');
      return;
    }
    if (!correo.contains('@')) {
      setState(() => _error = 'Ingresa un correo electrónico válido.');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      // Se reemplaza el ingreso simulado por la autenticación de la API.
      await GreenShieldApi.instance.login(correo, password);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserHomeScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
      if (e.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifica tu cuenta con el código que recibiste.')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _verificarCorreo() {
    final correo = _usuarioController.text.trim().toLowerCase();
    if (correo.isEmpty || !correo.contains('@')) {
      setState(() => _error = 'Escribe tu correo antes de verificar la cuenta.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerificationScreen(correo: correo),
      ),
    );
  }

  void _olvidoPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _crearCuenta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  // =====================================================
  // ACCESO TEMPORAL A ADMINISTRADOR (DEMO)
  // ⚠️ ELIMINAR CUANDO YA NO SEA NECESARIO
  // =====================================================
  void _accesoTemporalAdmin() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // INDICADOR SUPERIOR
                Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // TÍTULO
                const Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF1B5E20),
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Acceso temporal de administrador',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selecciona el perfil que deseas probar:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // =====================================================
                // PERFILES ADMINISTRATIVOS
                // =====================================================

                // ADMINISTRADOR DE INCENDIOS
                _opcionPerfilAdmin(
                  context: context,
                  icono: Icons.local_fire_department_outlined,
                  titulo: 'Administrador de Incendios',
                  subtitulo: 'Gestión de reportes, estadísticas y mapa de incendios',
                  rol: 'Administrador de reportes',
                  area: 'Incendios forestales',
                ),

                const SizedBox(height: 10),

                // ADMINISTRADOR DE TALA ILEGAL
                _opcionPerfilAdmin(
                  context: context,
                  icono: Icons.forest_outlined,
                  titulo: 'Administrador de Tala Ilegal',
                  subtitulo: 'Gestión de reportes, estadísticas y mapa de tala ilegal',
                  rol: 'Administrador de reportes',
                  area: 'Tala ilegal',
                ),

                const SizedBox(height: 10),

                // ADMINISTRADOR GLOBAL
                _opcionPerfilAdmin(
                  context: context,
                  icono: Icons.admin_panel_settings_outlined,
                  titulo: 'Administrador Global',
                  subtitulo: 'Control general y administración completa de GreenShield',
                  rol: 'Superadministrador',
                  area: 'Sistema completo',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _opcionPerfilAdmin({
    required BuildContext context,
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required String rol,
    required String area,
  }) {
    return Material(
      color: const Color(0xFFF4F8F5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomeScreen(
                rol: rol,
                area: area,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icono,
                  color: const Color(0xFF1B5E20),
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // LOGO
                    Image.asset(
                      'assets/images/logo_mambo.png',
                      width: 150,
                    ),

                    const SizedBox(height: 20),

                    // NOMBRE DE LA APP
                    const Text(
                      'GreenShield',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // DESCRIPCIÓN
                    const Text(
                      'Sistema de Monitoreo Ambiental',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // TÍTULO
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Inicio de sesión',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // CORREO ELECTRÓNICO
                    TextField(
                      controller: _usuarioController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'ejemplo@correo.com',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF145A32),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // CONTRASEÑA
                    TextField(
                      controller: _passwordController,
                      obscureText: _ocultarPassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _ocultarPassword =
                                  !_ocultarPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF145A32),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // OLVIDÓ SU CONTRASEÑA
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _olvidoPassword,
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Color(0xFF145A32),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (_error != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],

                    const SizedBox(height: 15),

                    // BOTÓN INICIAR SESIÓN
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _cargando ? null : _iniciarSesion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF145A32),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _cargando ? 'CONECTANDO...' : 'INICIAR SESIÓN',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // CREAR CUENTA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes una cuenta?',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: _crearCuenta,
                          child: const Text(
                            'Crear cuenta',
                            style: TextStyle(
                              color: Color(0xFF145A32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // NUEVA FUNCIÓN: verificación del correo registrado.
                    TextButton.icon(
                      onPressed: _cargando ? null : _verificarCorreo,
                      icon: const Icon(Icons.mark_email_read_outlined),
                      label: const Text('Tengo un código de verificación'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF145A32),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =====================================
                    // ACCESO TEMPORAL A ADMIN (DEMO)
                    // ⚠️ ELIMINAR DESPUÉS
                    // =====================================
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _accesoTemporalAdmin,
                        icon: const Icon(
                          Icons.admin_panel_settings,
                          color: Color(0xFF1B5E20),
                        ),
                        label: const Text(
                          'Acceso temporal admin',
                          style: TextStyle(
                            color: Color(0xFF1B5E20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF1B5E20),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // AVISO DE SEGURIDAD
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 16,
                          color: Colors.black45,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Acceso exclusivo para usuarios registrados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // EMPRESA
                    const Text(
                      'M.A.M.B.O.',
                      style: TextStyle(
                        fontSize: 13,
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
      ),
    );
  }
}