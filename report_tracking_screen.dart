import 'package:flutter/material.dart';

class ReportTrackingScreen extends StatelessWidget {
  const ReportTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Seguimiento de reportes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seguimiento',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF145A32),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Aquí podrás consultar el avance de tus reportes.',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // EJEMPLO DE ESTADO DEL REPORTE
            // ====================================================

            _estado(
              icon: Icons.send,
              titulo: 'Reporte enviado',
              descripcion:
                  'El reporte fue enviado correctamente.',
              activo: true,
            ),

            _linea(),

            _estado(
              icon: Icons.fact_check_outlined,
              titulo: 'En revisión',
              descripcion:
                  'El reporte está siendo revisado.',
              activo: true,
            ),

            _linea(),

            _estado(
              icon: Icons.engineering_outlined,
              titulo: 'Atención',
              descripcion:
                  'Pendiente de atención por parte de la autoridad.',
              activo: false,
            ),

            _linea(),

            _estado(
              icon: Icons.check_circle_outline,
              titulo: 'Finalizado',
              descripcion:
                  'El reporte ha sido atendido.',
              activo: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _estado({
    required IconData icon,
    required String titulo,
    required String descripcion,
    required bool activo,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: activo
              ? const Color(0xFF145A32)
              : Colors.grey.shade300,
          child: Icon(
            icon,
            color: activo
                ? Colors.white
                : Colors.grey.shade600,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                descripcion,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _linea() {
    return Container(
      margin: const EdgeInsets.only(
        left: 24,
        top: 5,
        bottom: 5,
      ),
      height: 35,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}