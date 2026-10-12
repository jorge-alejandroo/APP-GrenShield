import 'package:flutter/material.dart';
import '../services/greenshield_api.dart';
import 'email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombresController =
      TextEditingController();

  final TextEditingController _apellidoPaternoController =
      TextEditingController();

  final TextEditingController _apellidoMaternoController =
      TextEditingController();

  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  final TextEditingController _correoController =
      TextEditingController();

  final TextEditingController _telefonoController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmarPasswordController =
      TextEditingController();

  bool _ocultarPassword = true;
  bool _ocultarConfirmacion = true;
  DateTime? _fechaSeleccionada;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _fechaNacimientoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
    );

    if (fecha != null && mounted) {
      setState(() {
        _fechaSeleccionada = fecha;
        _fechaNacimientoController.text =
            '${fecha.day.toString().padLeft(2, '0')}/'
            '${fecha.month.toString().padLeft(2, '0')}/'
            '${fecha.year}';
      });
    }
  }

  String get _fechaISO {
    final fecha = _fechaSeleccionada!;
    return '${fecha.year.toString().padLeft(4, '0')}-'
        '${fecha.month.toString().padLeft(2, '0')}-'
        '${fecha.day.toString().padLeft(2, '0')}';
  }

  Future<void> _crearCuenta() async {
    final campos = [
      _nombresController.text.trim(),
      _apellidoPaternoController.text.trim(),
      _apellidoMaternoController.text.trim(),
      _correoController.text.trim(),
      _passwordController.text,
      _confirmarPasswordController.text,
    ];
    if (campos.any((campo) => campo.isEmpty) || _fechaSeleccionada == null) {
      setState(() => _error = 'Por favor, completa todos los campos obligatorios.');
      return;
    }
    if (!_correoController.text.trim().contains('@')) {
      setState(() => _error = 'Ingresa un correo electrónico válido.');
      return;
    }
    if (_passwordController.text.length < 8) {
      setState(() => _error = 'La contraseña debe contener al menos 8 caracteres.');
      return;
    }
    if (_passwordController.text != _confirmarPasswordController.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final correo = _correoController.text.trim().toLowerCase();
      final respuesta = await GreenShieldApi.instance.registrar({
        'nombres': _nombresController.text.trim(),
        'apellido_paterno': _apellidoPaternoController.text.trim(),
        'apellido_materno': _apellidoMaternoController.text.trim(),
        'fecha_nacimiento': _fechaISO,
        'correo': correo,
        'telefono': _telefonoController.text.trim().isEmpty
            ? null
            : _telefonoController.text.trim(),
        'contrasena': _passwordController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(respuesta['mensaje']?.toString() ?? 'Cuenta registrada.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationScreen(correo: correo),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  InputDecoration _decoracionCampo({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            30,
            10,
            30,
            40,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
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
                  children: [
                    Image.asset(
                      'assets/images/logo_mambo.png',
                      width: 120,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Regístrate para utilizar GreenShield',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // DATOS PERSONALES
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Datos personales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _nombresController,
                      decoration: _decoracionCampo(
                        label: 'Nombres',
                        hint: 'Ingresa tus nombres',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _apellidoPaternoController,
                      decoration: _decoracionCampo(
                        label: 'Apellido paterno',
                        hint: 'Ingresa tu apellido paterno',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _apellidoMaternoController,
                      decoration: _decoracionCampo(
                        label: 'Apellido materno',
                        hint: 'Ingresa tu apellido materno',
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _fechaNacimientoController,
                      readOnly: true,
                      onTap: _seleccionarFecha,
                      decoration: _decoracionCampo(
                        label: 'Fecha de nacimiento',
                        hint: 'Selecciona tu fecha',
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // DATOS DE ACCESO
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Datos de acceso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _decoracionCampo(
                        label: 'Correo electrónico',
                        hint: 'ejemplo@correo.com',
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: _decoracionCampo(
                        label: 'Teléfono (opcional)',
                        hint: 'Ingresa tu número telefónico',
                        icon: Icons.phone_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _passwordController,
                      obscureText: _ocultarPassword,
                      decoration: _decoracionCampo(
                        label: 'Contraseña',
                        hint: 'Crea una contraseña',
                        icon: Icons.lock_outline,
                      ).copyWith(
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
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: _confirmarPasswordController,
                      obscureText: _ocultarConfirmacion,
                      decoration: _decoracionCampo(
                        label: 'Confirmar contraseña',
                        hint: 'Repite tu contraseña',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarConfirmacion
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _ocultarConfirmacion =
                                  !_ocultarConfirmacion;
                            });
                          },
                        ),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _cargando ? null : _crearCuenta,
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
                          _cargando ? 'REGISTRANDO...' : 'CREAR CUENTA',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Al crear una cuenta podrás enviar reportes '
                      'y consultar su seguimiento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      label: const Text(
                        'Volver al inicio de sesión',
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