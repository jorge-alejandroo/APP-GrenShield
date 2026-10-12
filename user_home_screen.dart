import 'package:flutter/material.dart';

// Pantallas que ya tenemos creadas
import 'profile_screen.dart';
import 'login_screen.dart';
import '../services/greenshield_api.dart';
import 'notifications_screen.dart';
import 'reports_screen.dart';
import 'report_tracking_screen.dart';
import 'settings_screen.dart';
import 'fire_report_screen.dart';
import 'illegal_logging_report_screen.dart';

// Nueva pantalla de noticias
import 'news_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  // ============================================================
  // FUNCIÓN PARA CERRAR SESIÓN
  // ============================================================
  //
  // Revoca el JWT actual en FastAPI y regresa al login.
  // Si no hay conexión, elimina el token local y su caducidad
  // en el servidor ocurrirá según la configuración de JWT.
  // ============================================================

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar tu sesión de GreenShield?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cerrar sesión')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await GreenShieldApi.instance.logout();
    } catch (_) {
      // El JWT local se elimina incluso si no hay red; en el servidor
      // seguirá siendo válido hasta caducar si no pudo revocarse.
    }
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
  }

  // ============================================================
  // FUNCIÓN PARA CREAR ELEMENTOS DEL MENÚ
  // ============================================================
  //
  // Se utiliza para evitar repetir el mismo código en cada
  // opción del Drawer.
  // ============================================================

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF145A32),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ==========================================================
      // MENÚ LATERAL
      // ==========================================================

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              // --------------------------------------------------
              // ENCABEZADO DEL MENÚ
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF145A32),
                ),
                child: Column(
                  children: [

                    // Avatar del usuario
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Color(0xFF145A32),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Usuario GreenShield',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------
              // OPCIONES DEL MENÚ
              // --------------------------------------------------

              const SizedBox(height: 10),

              // Mi perfil
              _menuItem(
                context: context,
                icon: Icons.person_outline,
                title: 'Mi perfil',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),

              // --------------------------------------------------
              // NOTICIAS
              // --------------------------------------------------
              //
              // Las noticias son información general:
              // - Prevención de incendios
              // - Información ambiental
              // - Tala ilegal
              // - Actualizaciones de GreenShield
              //
              // NO son las notificaciones personales del usuario.
              // --------------------------------------------------

              _menuItem(
                context: context,
                icon: Icons.article_outlined,
                title: 'Noticias',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewsScreen(),
                    ),
                  );
                },
              ),

              // Mis reportes
              _menuItem(
                context: context,
                icon: Icons.description_outlined,
                title: 'Mis reportes',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportsScreen(),
                    ),
                  );
                },
              ),

              // Seguimiento de reportes
              _menuItem(
                context: context,
                icon: Icons.track_changes,
                title: 'Seguimiento de reportes',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ReportTrackingScreen(),
                    ),
                  );
                },
              ),

              // Configuración
              _menuItem(
                context: context,
                icon: Icons.settings_outlined,
                title: 'Configuración',
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),

              const Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),

              // --------------------------------------------------
              // CERRAR SESIÓN
              // --------------------------------------------------

              _menuItem(
                context: context,
                icon: Icons.logout,
                title: 'Cerrar sesión',
                onTap: () {
                  Navigator.pop(context);
                  _cerrarSesion(context);
                },
              ),

              const Spacer(),

              // --------------------------------------------------
              // VERSIÓN
              // --------------------------------------------------

              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'GreenShield v1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // BARRA SUPERIOR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,

        // Título
        title: const Text(
          'GreenShield',
          style: TextStyle(
            color: Color(0xFF145A32),
            fontWeight: FontWeight.bold,
          ),
        ),

        // --------------------------------------------------------
        // BOTÓN DE NOTIFICACIONES
        // --------------------------------------------------------
        //
        // Ahora las notificaciones están aquí y ya NO aparecen
        // dentro del menú lateral.
        // --------------------------------------------------------

        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF145A32),
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationsScreen(),
                ),
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ==========================================================
      // CONTENIDO PRINCIPAL
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // --------------------------------------------------
              // LOGO
              // --------------------------------------------------

              Image.asset(
                'assets/images/logo_mambo.png',
                height: 110,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.eco,
                    size: 90,
                    color: Color(0xFF145A32),
                  );
                },
              ),

              const SizedBox(height: 15),

              // --------------------------------------------------
              // MENSAJE DE BIENVENIDA
              // --------------------------------------------------

              const Text(
                '¡Bienvenido a GreenShield!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF145A32),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Selecciona el tipo de reporte que deseas realizar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 35),

              // ==================================================
              // BOTÓN: REPORTE DE INCENDIOS
              // ==================================================

              _reporteButton(
                context: context,
                icon: Icons.local_fire_department,
                title: 'Reporte de incendios',
                subtitle: 'Reportar un posible incendio forestal',
                color: const Color(0xFFD84315),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FireReportScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // BOTÓN: REPORTE DE TALA ILEGAL
              // ==================================================

              _reporteButton(
                context: context,
                icon: Icons.forest,
                title: 'Reporte de tala ilegal',
                subtitle: 'Reportar una posible tala ilegal',
                color: const Color(0xFF2E7D32),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const IllegalLoggingReportScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // INFORMACIÓN
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF145A32),
                      size: 28,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Utiliza GreenShield para enviar reportes '
                        'sobre posibles incendios forestales o tala ilegal.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF145A32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTÓN PRINCIPAL DE REPORTE
  // ============================================================

  Widget _reporteButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          elevation: 3,
        ),

        child: Row(
          children: [

            // Icono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 35,
              ),
            ),

            const SizedBox(width: 18),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}