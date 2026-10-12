import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/greenshield_api.dart';

/// Nueva pantalla, diseñada con la misma línea visual que las pantallas v1.
class EmailVerificationScreen extends StatefulWidget {
  final String correo;

  const EmailVerificationScreen({super.key, required this.correo});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codigoController = TextEditingController();
  bool _enviando = false;
  String? _mensaje;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (_codigoController.text.trim().length != 6) {
      setState(() => _mensaje = 'Ingresa los seis números que recibiste por correo.');
      return;
    }

    setState(() {
      _enviando = true;
      _mensaje = null;
    });
    try {
      await GreenShieldApi.instance.verificarRegistro(
        widget.correo,
        _codigoController.text.trim(),
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Correo verificado'),
          content: const Text('Tu cuenta ya está verificada. Puedes iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _mensaje = e.message);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _reenviar() async {
    String password = '';
    final clave = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reenviar código'),
        content: TextField(
          obscureText: true,
          autofocus: true,
          onChanged: (value) => password = value,
          decoration: InputDecoration(
            labelText: 'Contraseña de tu cuenta',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, password),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF145A32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reenviar'),
          ),
        ],
      ),
    );
    if (!mounted || clave == null || clave.isEmpty) return;

    setState(() {
      _enviando = true;
      _mensaje = null;
    });
    try {
      final respuesta = await GreenShieldApi.instance.reenviarVerificacion(
        widget.correo,
        clave,
      );
      if (mounted) {
        setState(() => _mensaje = respuesta['mensaje']?.toString() ??
            'Enviamos otro código a tu correo.');
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _mensaje = e.message);
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
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
          'Verificar correo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
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
                    Image.asset('assets/images/logo_mambo.png', width: 120),
                    const SizedBox(height: 15),
                    const Icon(
                      Icons.mark_email_read_outlined,
                      size: 40,
                      color: Color(0xFF145A32),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Confirma tu cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enviamos un código de 6 dígitos a ${widget.correo}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _codigoController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 23, letterSpacing: 7),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Código de 6 dígitos',
                        prefixIcon: const Icon(Icons.pin_outlined),
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
                    if (_mensaje != null) ...[
                      const SizedBox(height: 16),
                      Text(_mensaje!, textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _enviando ? null : _confirmar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF145A32),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _enviando ? 'VERIFICANDO...' : 'VERIFICAR CORREO',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _enviando ? null : _reenviar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reenviar código'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF145A32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El código vence a los 15 minutos y solo se puede usar una vez.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF145A32),
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
