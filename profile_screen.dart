import 'package:flutter/material.dart';
import 'change_email_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.guardarTelefonoEnApi});

  /// Debe llamar al endpoint autenticado del backend y lanzar una
  /// excepción si la actualización no se guardó en la base de datos.
  /// Al no proporcionarse, el perfil no simula falsamente el guardado.
  final Future<void> Function(String numero)? guardarTelefonoEnApi;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================
  // DATOS DEL USUARIO
  // ============================================================
  //
  // Estos datos todavía son de ejemplo. La lectura del perfil desde
  // la base de datos debe conectarse al servicio de autenticación.
  //
  // IMPORTANTE:
  // Nombre, apellidos y fecha de nacimiento NO serán editables
  // de acuerdo con los requisitos establecidos para GreenShield.
  // ============================================================

  String nombre = 'Usuario';
  String apellidoPaterno = 'GreenShield';
  String apellidoMaterno = '';
  String fechaNacimiento = '01/01/2000';

  String correo = 'usuario@greenshield.com';
  String telefono = '961 000 0000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Mi perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // ==================================================
            // FOTO / ICONO DEL USUARIO
            // ==================================================

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF145A32),
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              '$nombre $apellidoPaterno',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF145A32),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // DATOS PERSONALES
            // ==================================================

            _seccionTitulo('Datos personales'),

            _campoInformacion(
              icon: Icons.person_outline,
              titulo: 'Nombre',
              valor: nombre,
              editable: false,
            ),

            _campoInformacion(
              icon: Icons.person_outline,
              titulo: 'Apellido paterno',
              valor: apellidoPaterno,
              editable: false,
            ),

            _campoInformacion(
              icon: Icons.person_outline,
              titulo: 'Apellido materno',
              valor: apellidoMaterno.isEmpty
                  ? 'No registrado'
                  : apellidoMaterno,
              editable: false,
            ),

            _campoInformacion(
              icon: Icons.calendar_today_outlined,
              titulo: 'Fecha de nacimiento',
              valor: fechaNacimiento,
              editable: false,
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DATOS DE CONTACTO
            // ==================================================

            _seccionTitulo('Datos de contacto'),

            _campoEditable(
              icon: Icons.email_outlined,
              titulo: 'Correo electrónico',
              valor: correo,
              onTap: _cambiarCorreo,

            ),

            _campoEditable(
              icon: Icons.phone_outlined,
              titulo: 'Teléfono',
              valor: telefono,
              onTap: () {
                _editarTelefono();
              },
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CONTRASEÑA
            // ==================================================

            _seccionTitulo('Seguridad'),

            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              leading: const Icon(
                Icons.lock_outline,
                color: Color(0xFF145A32),
              ),
              title: const Text(
                'Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Cambiar contraseña',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                _cambiarPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TÍTULO DE SECCIÓN
  // ============================================================

  Widget _seccionTitulo(String titulo) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF145A32),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN NO EDITABLE
  // ============================================================

  Widget _campoInformacion({
    required IconData icon,
    required String titulo,
    required String valor,
    required bool editable,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF145A32),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.lock_outline,
          size: 18,
          color: Colors.black38,
        ),
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN EDITABLE
  // ============================================================

  Widget _campoEditable({
    required IconData icon,
    required String titulo,
    required String valor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF145A32),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.edit_outlined,
          size: 20,
          color: Color(0xFF145A32),
        ),
        onTap: onTap,
      ),
    );
  }

  // ============================================================
  // CAMBIAR CORREO VERIFICADO / EDITAR TELÉFONO SIMULADO
  // ============================================================

  Future<void> _cambiarCorreo() async {
    final nuevoCorreo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ChangeEmailScreen()),
    );
    if (!mounted || nuevoCorreo == null) return;
    setState(() => correo = nuevoCorreo);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Correo electrónico actualizado correctamente.')),
    );
  }

  Future<void> _editarTelefono() async {
    final controller = TextEditingController(text: telefono);
    bool guardando = false;
    String? mensaje;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogBuildContext, actualizarDialogo) => AlertDialog(
          title: const Text('Cambiar Teléfono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                enabled: !guardando,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              if (mensaje != null) ...[
                const SizedBox(height: 12),
                Text(
                  mensaje!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: guardando
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: guardando ? null : () async {
                final nuevoNumero = controller.text.trim();
                final soloDigitos = nuevoNumero.replaceAll(RegExp(r'[^0-9]'), '');
                if (soloDigitos.length < 10 || soloDigitos.length > 15) {
                  actualizarDialogo(() {
                    mensaje = 'Introduce un número válido de 10 a 15 dígitos.';
                  });
                  return;
                }
                if (nuevoNumero == telefono) {
                  Navigator.of(dialogContext).pop();
                  return;
                }
                final guardar = widget.guardarTelefonoEnApi;
                if (guardar == null) {
                  actualizarDialogo(() {
                    mensaje = 'No se guardó el teléfono: todavía falta conectar '
                        'el servicio de actualización del perfil con la API.';
                  });
                  return;
                }

                actualizarDialogo(() {
                  guardando = true;
                  mensaje = null;
                });
                try {
                  await guardar(nuevoNumero);
                  if (!mounted || !dialogContext.mounted) return;
                  setState(() => telefono = nuevoNumero);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Teléfono actualizado correctamente.'),
                    ),
                  );
                } catch (error) {
                  if (dialogContext.mounted) {
                    actualizarDialogo(() {
                      mensaje = 'No se pudo actualizar el teléfono: $error';
                    });
                  }
                } finally {
                  if (dialogContext.mounted) {
                    actualizarDialogo(() => guardando = false);
                  }
                }
              },
              child: guardando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }

  // ============================================================
  // CAMBIAR CONTRASEÑA
  // ============================================================

  void _cambiarPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'La función para cambiar la contraseña se conectará posteriormente.',
        ),
      ),
    );
  }
}