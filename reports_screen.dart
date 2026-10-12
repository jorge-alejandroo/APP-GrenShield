import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // MIS REPORTES
    // ============================================================
    //
    // Los reportes son de ejemplo por ahora.
    //
    // Posteriormente esta información se obtendrá de la base
    // de datos mediante la API.
    // ============================================================

    final reports = [
      {
        'type': 'Incendio forestal',
        'date': '29/09/2026',
        'status': 'Recibido',
        'icon': Icons.local_fire_department,
      },
      {
        'type': 'Tala ilegal',
        'date': '25/09/2026',
        'status': 'En revisión',
        'icon': Icons.forest,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Mis reportes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor:
                            const Color(0xFF145A32)
                                .withValues(alpha: 0.1),
                        child: Icon(
                          report['icon'] as IconData,
                          color: const Color(0xFF145A32),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['type'] as String,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Fecha: ${report['date']}',
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Estado: ${report['status']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}