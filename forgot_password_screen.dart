import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/greenshield_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nuevaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();
  bool _codigoSolicitado = false;
  bool _cargando = false;
  bool _mostrarClave = false;
  String? _mensaje;

  @override
  void dispose() {
    _correoController.dispose();
    _codigoController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _solicitarCodigo() async {
    final correo = _correoController.text.trim().toLowerCase();
    if (!correo.contains('@')) {
      setState(() => _mensaje = 'Escribe un correo electrónico válido.');
      return;
    }
    setState(() {
      _cargando = true;
      _mensaje = null;
    });
    try {
      final respuesta = await GreenShieldApi.instance.solicitarRecuperacion(correo);
      if (!mounted) return;
      setState(() {
        _codigoSolicitado = true;
        _mensaje = respuesta['mensaje']?.toString();
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _mensaje = e.message);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _restablecer() async {
    if (_codigoController.text.length != 6 ||
        _nuevaController.text.length < 8 ||
        _nuevaController.text != _confirmarController.text) {
      setState(() => _mensaje =
          'Revisa el código de 6 dígitos y confirma una contraseña nueva de al menos 8 caracteres.');
      return;
    }
    setState(() {
      _cargando = true;
      _mensaje = null;
    });
    try {
      await GreenShieldApi.instance.confirmarRecuperacion(
        _correoController.text.trim().toLowerCase(),
        _codigoController.text,
        _nuevaController.text,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Contraseña actualizada'),
          content: const Text('Ya puedes iniciar sesión con tu nueva contraseña.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      if (mounted) setState(() => _mensaje = e.message);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  InputDecoration _decoracionCampo(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF145A32), width: 2),
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
          'Recuperar contraseña',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  children: [
                    Image.asset(
                      'assets/images/logo_mambo.png',
                      width: 130,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      _codigoSolicitado
                          ? 'Introduce el código recibido'
                          : '¿Olvidaste tu contraseña?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      _codigoSolicitado
                          ? 'Revisa tu correo e introduce el código de 6 dígitos junto con tu nueva contraseña.'
                          : 'Ingresa el correo electrónico asociado a tu cuenta para recibir un código de recuperación.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: _correoController,
                      enabled: !_codigoSolicitado,
                      keyboardType:
                          TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'ejemplo@correo.com',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF145A32),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (_codigoSolicitado) ...[
                      const SizedBox(height: 18),
                      TextField(
                        controller: _codigoController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: _decoracionCampo(
                          'Código de 6 dígitos',
                          Icons.pin_outlined,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nuevaController,
                        obscureText: !_mostrarClave,
                        decoration: _decoracionCampo(
                          'Nueva contraseña',
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_mostrarClave
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _mostrarClave = !_mostrarClave),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _confirmarController,
                        obscureText: !_mostrarClave,
                        decoration: _decoracionCampo(
                          'Confirmar contraseña',
                          Icons.lock_outline,
                        ),
                      ),
                    ],
                    if (_mensaje != null) ...[
                      const SizedBox(height: 16),
                      Text(_mensaje!, textAlign: TextAlign.center),
                    ],

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _cargando ? null : (_codigoSolicitado ? _restablecer : _solicitarCodigo),
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
                          _cargando
                              ? 'PROCESANDO...'
                              : (_codigoSolicitado ? 'CAMBIAR CONTRASEÑA' : 'ENVIAR CÓDIGO'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    if (_codigoSolicitado) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _cargando ? null : _solicitarCodigo,
                        child: const Text('Solicitar otro código'),
                      ),
                    ],

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