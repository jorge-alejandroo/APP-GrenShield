import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // NOTIFICACIONES
    // ============================================================
    //
    // Actualmente utilizamos información de ejemplo.
    //
    // Posteriormente estas notificaciones vendrán del servidor
    // dependiendo del estado de los reportes del usuario.
    // ============================================================

    final notifications = [
      {
        'icon': Icons.check_circle_outline,
        'title': 'Reporte recibido',
        'message':
            'Tu reporte ha sido recibido correctamente.',
        'time': 'Hace 10 minutos',
      },
      {
        'icon': Icons.update,
        'title': 'Reporte actualizado',
        'message':
            'El estado de uno de tus reportes ha cambiado.',
        'time': 'Ayer',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No tienes notificaciones.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(15),
                    leading: Icon(
                      notification['icon']
                          as IconData,
                      color: const Color(0xFF145A32),
                      size: 30,
                    ),
                    title: Text(
                      notification['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: 5),
                      child: Text(
                        notification['message']
                            as String,
                      ),
                    ),
                    trailing: Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}