import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ==========================================================
      // BARRA SUPERIOR
      // ==========================================================

      appBar: AppBar(
        title: const Text(
          'Noticias',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF145A32),
        foregroundColor: Colors.white,
      ),

      // ==========================================================
      // LISTA DE NOTICIAS
      // ==========================================================

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ======================================================
          // NOTICIA 1
          // ======================================================

          _newsCard(
            context: context,
            icon: Icons.local_fire_department,
            title: 'Prevención de incendios forestales',
            date: 'Información general',
            description:
                'Conoce algunas recomendaciones para ayudar a '
                'prevenir incendios forestales y proteger las áreas '
                'naturales.',
            color: const Color(0xFFD84315),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // NOTICIA 2
          // ======================================================

          _newsCard(
            context: context,
            icon: Icons.forest,
            title: 'Información sobre tala ilegal',
            date: 'Información ambiental',
            description:
                'Conoce la importancia de proteger los bosques y '
                'reportar actividades que puedan afectar las áreas '
                'forestales.',
            color: const Color(0xFF2E7D32),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // NOTICIA 3
          // ======================================================

          _newsCard(
            context: context,
            icon: Icons.phone_android,
            title: 'Nuevas funciones de GreenShield',
            date: 'Actualización de la aplicación',
            description:
                'GreenShield continúa incorporando funciones para '
                'facilitar el envío y seguimiento de reportes.',
            color: const Color(0xFF1565C0),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // NOTICIA 4
          // ======================================================

          _newsCard(
            context: context,
            icon: Icons.public,
            title: 'Cuidado del medio ambiente',
            date: 'Información ambiental',
            description:
                'Mantente informado sobre temas relacionados con '
                'el cuidado de los bosques y la protección del '
                'medio ambiente.',
            color: const Color(0xFF6A1B9A),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA DE NOTICIA
  // ============================================================

  Widget _newsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String date,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --------------------------------------------------
            // ICONO Y TÍTULO
            // --------------------------------------------------

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // --------------------------------------------------
            // DESCRIPCIÓN
            // --------------------------------------------------

            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // BOTÓN "LEER MÁS"
            // --------------------------------------------------
            //
            // Por ahora solamente muestra un mensaje.
            //
            // Más adelante podemos hacer que abra una noticia
            // completa obtenida desde el servidor.
            // --------------------------------------------------

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Contenido completo próximamente.',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Leer más',
                  style: TextStyle(
                    color: Color(0xFF145A32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}