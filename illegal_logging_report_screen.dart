import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/report_location_picker.dart';

class IllegalLoggingReportScreen extends StatefulWidget {
  const IllegalLoggingReportScreen({super.key});

  @override
  State<IllegalLoggingReportScreen> createState() =>
      _IllegalLoggingReportScreenState();
}

class _IllegalLoggingReportScreenState
    extends State<IllegalLoggingReportScreen> {
  // ============================================================
  // PASOS DEL REPORTE
  // ============================================================
  //
  // 0 = Información
  // 1 = Evidencia
  // 2 = Ubicación
  // 3 = Confirmación
  // ============================================================

  int _currentStep = 0;

  // ============================================================
  // RESPUESTAS DEL CUESTIONARIO
  // ============================================================

  String? _actividadObservada;
  String? _actividadActual;
  String? _vehiculosMaquinaria;
  String? _cantidadArboles;

  final TextEditingController _descripcionController =
      TextEditingController();

  // ============================================================
  // EVIDENCIAS
  // ============================================================

  bool _tieneFoto = false;
  bool _tieneVideo = false;
  bool _tieneAudio = false;

  // ============================================================
  // UBICACIÓN
  // ============================================================

  bool _ubicacionConfirmada = false;
  LatLng? _coordenadasConfirmadas;

  // ============================================================
  // CONTROLADOR DE PÁGINAS
  // ============================================================

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _descripcionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // AVANZAR
  // ============================================================

  void _siguientePaso() {
    if (_currentStep == 0) {
      if (!_validarInformacion()) {
        return;
      }
    }

    if (_currentStep == 1) {
      if (!_validarEvidencia()) {
        return;
      }
    }

    if (_currentStep == 2) {
      if (!_ubicacionConfirmada) {
        _mostrarMensaje(
          'Confirma la ubicación del reporte para continuar.',
        );
        return;
      }
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ============================================================
  // REGRESAR
  // ============================================================

  void _pasoAnterior() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ============================================================
  // VALIDAR INFORMACIÓN
  // ============================================================

  bool _validarInformacion() {
    if (_actividadObservada == null) {
      _mostrarMensaje(
        'Selecciona qué actividad observas.',
      );
      return false;
    }

    if (_actividadActual == null) {
      _mostrarMensaje(
        'Indica si la actividad está ocurriendo actualmente.',
      );
      return false;
    }

    if (_vehiculosMaquinaria == null) {
      _mostrarMensaje(
        'Indica si observas vehículos o maquinaria.',
      );
      return false;
    }

    if (_cantidadArboles == null) {
      _mostrarMensaje(
        'Selecciona una cantidad aproximada de árboles.',
      );
      return false;
    }

    return true;
  }

  // ============================================================
  // VALIDAR EVIDENCIA
  // ============================================================

  bool _validarEvidencia() {
    if (!_tieneFoto && !_tieneVideo && !_tieneAudio) {
      _mostrarMensaje(
        'Agrega al menos una evidencia: foto, video o audio.',
      );
      return false;
    }

    return true;
  }

  // ============================================================
  // MOSTRAR MENSAJE
  // ============================================================

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // FOTOGRAFÍA
  // ============================================================

  void _agregarFoto() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    // Más adelante conectaremos la cámara o galería real.
    // ----------------------------------------------------------

    setState(() {
      _tieneFoto = true;
    });

    _mostrarMensaje(
      'Fotografía agregada correctamente.',
    );
  }

  // ============================================================
  // VIDEO
  // ============================================================

  void _agregarVideo() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    // Más adelante conectaremos la grabación de video real.
    // ----------------------------------------------------------

    setState(() {
      _tieneVideo = true;
    });

    _mostrarMensaje(
      'Video agregado correctamente.',
    );
  }

  // ============================================================
  // AUDIO
  // ============================================================

  void _agregarAudio() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    // Más adelante conectaremos una grabadora de audio real.
    // ----------------------------------------------------------

    setState(() {
      _tieneAudio = true;
    });

    _mostrarMensaje(
      'Audio agregado correctamente.',
    );
  }

  // ============================================================
  // CONFIRMAR UBICACIÓN
  // ============================================================

  void _cambiarUbicacion(LatLng? nuevaUbicacion) {
    setState(() {
      _coordenadasConfirmadas = nuevaUbicacion;
      _ubicacionConfirmada = nuevaUbicacion != null;
    });
    if (nuevaUbicacion != null) {
      _mostrarMensaje('Ubicacion confirmada correctamente.');
    }
  }

  // ============================================================
  // ENVIAR REPORTE
  // ============================================================

  void _enviarReporte() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    //
    // El folio real deberá generarse en el servidor.
    //
    // Para esta simulación utilizamos un folio con el prefijo
    // TAL para diferenciarlo de los reportes de incendios.
    // ----------------------------------------------------------

    const String folio = 'TAL-2026-000001';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Color(0xFF2E7D32),
            size: 60,
          ),

          title: const Text(
            'Reporte enviado',
            textAlign: TextAlign.center,
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tu reporte de tala ilegal fue registrado '
                'correctamente.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Folio del reporte',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      folio,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Guarda este número para consultar '
                'el seguimiento de tu reporte.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF145A32),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Volver al inicio',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CONSTRUCCIÓN PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reporte de tala ilegal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF145A32),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: _currentStep < 3,
      ),

      body: Column(
        children: [
          _buildProgressIndicator(),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildInformacionPaso(),
                _buildEvidenciaPaso(),
                _buildUbicacionPaso(),
                _buildConfirmacionPaso(),
              ],
            ),
          ),

          if (_currentStep < 3)
            _buildNavigationButtons(),
        ],
      ),
    );
  }

  // ============================================================
  // INDICADOR DE PROGRESO
  // ============================================================

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      color: Colors.white,
      child: Row(
        children: [
          _progressItem(
            number: '1',
            title: 'Información',
            active: _currentStep >= 0,
          ),

          _progressLine(),

          _progressItem(
            number: '2',
            title: 'Evidencia',
            active: _currentStep >= 1,
          ),

          _progressLine(),

          _progressItem(
            number: '3',
            title: 'Ubicación',
            active: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ELEMENTO DE PROGRESO
  // ============================================================

  Widget _progressItem({
    required String number,
    required String title,
    required bool active,
  }) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: active
                ? const Color(0xFF145A32)
                : Colors.grey.shade300,
            child: Text(
              number,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: active
                  ? const Color(0xFF145A32)
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LÍNEA DEL PROGRESO
  // ============================================================

  Widget _progressLine() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  // ============================================================
  // PASO 1: INFORMACIÓN
  // ============================================================

  Widget _buildInformacionPaso() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.forest,
            size: 50,
            color: Color(0xFF2E7D32),
          ),

          const SizedBox(height: 10),

          const Text(
            'Información de la situación',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Selecciona las opciones que describan '
            'mejor lo que estás observando.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // ACTIVIDAD OBSERVADA
          // ------------------------------------------------------

          _questionTitle(
            '¿Qué actividad observas?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Corte de árboles',
            icon: Icons.content_cut,
            selected: _actividadObservada ==
                'Corte de árboles',
            onTap: () {
              setState(() {
                _actividadObservada =
                    'Corte de árboles';
              });
            },
          ),

          _selectionCard(
            title: 'Transporte de madera',
            icon: Icons.local_shipping_outlined,
            selected: _actividadObservada ==
                'Transporte de madera',
            onTap: () {
              setState(() {
                _actividadObservada =
                    'Transporte de madera';
              });
            },
          ),

          _selectionCard(
            title: 'Acumulación de madera',
            icon: Icons.view_module_outlined,
            selected: _actividadObservada ==
                'Acumulación de madera',
            onTap: () {
              setState(() {
                _actividadObservada =
                    'Acumulación de madera';
              });
            },
          ),

          _selectionCard(
            title: 'Árboles recientemente cortados',
            icon: Icons.forest_outlined,
            selected: _actividadObservada ==
                'Árboles recientemente cortados',
            onTap: () {
              setState(() {
                _actividadObservada =
                    'Árboles recientemente cortados';
              });
            },
          ),

          _selectionCard(
            title: 'Otra actividad',
            icon: Icons.help_outline,
            selected: _actividadObservada ==
                'Otra actividad',
            onTap: () {
              setState(() {
                _actividadObservada =
                    'Otra actividad';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // ACTIVIDAD ACTUAL
          // ------------------------------------------------------

          _questionTitle(
            '¿La actividad está ocurriendo actualmente?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Sí',
            icon: Icons.visibility,
            selected: _actividadActual == 'Sí',
            onTap: () {
              setState(() {
                _actividadActual = 'Sí';
              });
            },
          ),

          _selectionCard(
            title: 'No',
            icon: Icons.check_circle_outline,
            selected: _actividadActual == 'No',
            onTap: () {
              setState(() {
                _actividadActual = 'No';
              });
            },
          ),

          _selectionCard(
            title: 'No estoy seguro',
            icon: Icons.help_outline,
            selected: _actividadActual ==
                'No estoy seguro',
            onTap: () {
              setState(() {
                _actividadActual =
                    'No estoy seguro';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // VEHÍCULOS O MAQUINARIA
          // ------------------------------------------------------

          _questionTitle(
            '¿Observas vehículos o maquinaria relacionados?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Sí',
            icon: Icons.construction,
            selected: _vehiculosMaquinaria == 'Sí',
            onTap: () {
              setState(() {
                _vehiculosMaquinaria = 'Sí';
              });
            },
          ),

          _selectionCard(
            title: 'No',
            icon: Icons.check_circle_outline,
            selected: _vehiculosMaquinaria == 'No',
            onTap: () {
              setState(() {
                _vehiculosMaquinaria = 'No';
              });
            },
          ),

          _selectionCard(
            title: 'No estoy seguro',
            icon: Icons.help_outline,
            selected:
                _vehiculosMaquinaria ==
                    'No estoy seguro',
            onTap: () {
              setState(() {
                _vehiculosMaquinaria =
                    'No estoy seguro';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // CANTIDAD DE ÁRBOLES
          // ------------------------------------------------------

          _questionTitle(
            '¿Cuántos árboles aproximadamente están afectados?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: '1 - 5',
            icon: Icons.filter_1,
            selected: _cantidadArboles == '1 - 5',
            onTap: () {
              setState(() {
                _cantidadArboles = '1 - 5';
              });
            },
          ),

          _selectionCard(
            title: '6 - 10',
            icon: Icons.filter_6,
            selected: _cantidadArboles == '6 - 10',
            onTap: () {
              setState(() {
                _cantidadArboles = '6 - 10';
              });
            },
          ),

          _selectionCard(
            title: 'Más de 10',
            icon: Icons.add_circle_outline,
            selected:
                _cantidadArboles == 'Más de 10',
            onTap: () {
              setState(() {
                _cantidadArboles = 'Más de 10';
              });
            },
          ),

          _selectionCard(
            title: 'No sé',
            icon: Icons.help_outline,
            selected: _cantidadArboles == 'No sé',
            onTap: () {
              setState(() {
                _cantidadArboles = 'No sé';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // DESCRIPCIÓN
          // ------------------------------------------------------

          _questionTitle(
            'Descripción adicional',
            required: false,
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _descripcionController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText:
                  'Describe cualquier detalle que consideres importante...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // PASO 2: EVIDENCIA
  // ============================================================

  Widget _buildEvidenciaPaso() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.perm_media_outlined,
            size: 55,
            color: Color(0xFF145A32),
          ),

          const SizedBox(height: 10),

          const Text(
            'Evidencia',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Agrega fotografías, videos o audio que puedan '
            'ayudar a documentar el reporte.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 30),

          // FOTO

          _evidenceButton(
            icon: Icons.camera_alt,
            title: 'Fotografía',
            subtitle: _tieneFoto
                ? 'Fotografía agregada ✓'
                : 'Tomar o seleccionar fotografía',
            color: const Color(0xFF1565C0),
            added: _tieneFoto,
            onTap: _agregarFoto,
          ),

          const SizedBox(height: 15),

          // VIDEO

          _evidenceButton(
            icon: Icons.videocam,
            title: 'Video',
            subtitle: _tieneVideo
                ? 'Video agregado ✓'
                : 'Grabar o seleccionar video',
            color: const Color(0xFF6A1B9A),
            added: _tieneVideo,
            onTap: _agregarVideo,
          ),

          const SizedBox(height: 15),

          // AUDIO

          _evidenceButton(
            icon: Icons.mic,
            title: 'Audio',
            subtitle: _tieneAudio
                ? 'Audio agregado ✓'
                : 'Grabar un audio',
            color: const Color(0xFFEF6C00),
            added: _tieneAudio,
            onTap: _agregarAudio,
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(0xFFF57F17),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Agrega al menos una evidencia. '
                    'No es necesario agregar los tres tipos.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6D4C00),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PASO 3: UBICACIÓN
  // ============================================================

  Widget _buildUbicacionPaso() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.location_on,
            size: 55,
            color: Color(0xFFD32F2F),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ubicacion del reporte',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Confirma en el mapa el lugar donde se observo la actividad.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 25),
          ReportLocationPicker(
            initialConfirmedLocation: _coordenadasConfirmadas,
            isConfirmed: _ubicacionConfirmada,
            onLocationChanged: _cambiarUbicacion,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // PASO 4: CONFIRMACIÓN
  // ============================================================

  Widget _buildConfirmacionPaso() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const Icon(
            Icons.fact_check_outlined,
            size: 70,
            color: Color(0xFF145A32),
          ),

          const SizedBox(height: 15),

          const Text(
            'Revisa tu reporte',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Verifica que la información sea correcta '
            'antes de enviarla.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // INFORMACIÓN
          // ------------------------------------------------------

          _summaryCard(
            title: 'Información de la situación',
            icon: Icons.forest,
            children: [
              _summaryRow(
                'Actividad',
                _actividadObservada ??
                    'No especificada',
              ),
              _summaryRow(
                'Actualmente',
                _actividadActual ??
                    'No especificado',
              ),
              _summaryRow(
                'Vehículos',
                _vehiculosMaquinaria ??
                    'No especificado',
              ),
              _summaryRow(
                'Árboles',
                _cantidadArboles ??
                    'No especificado',
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ------------------------------------------------------
          // DESCRIPCIÓN
          // ------------------------------------------------------

          _summaryCard(
            title: 'Descripción',
            icon: Icons.description_outlined,
            children: [
              _summaryRow(
                'Comentario',
                _descripcionController.text.isEmpty
                    ? 'Sin descripción adicional'
                    : _descripcionController.text,
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ------------------------------------------------------
          // EVIDENCIA
          // ------------------------------------------------------

          _summaryCard(
            title: 'Evidencia',
            icon: Icons.perm_media_outlined,
            children: [
              if (_tieneFoto)
                _summaryRow(
                  'Fotografía',
                  'Agregada ✓',
                ),

              if (_tieneVideo)
                _summaryRow(
                  'Video',
                  'Agregado ✓',
                ),

              if (_tieneAudio)
                _summaryRow(
                  'Audio',
                  'Agregado ✓',
                ),
            ],
          ),

          const SizedBox(height: 15),

          // ------------------------------------------------------
          // UBICACIÓN
          // ------------------------------------------------------

          _summaryCard(
            title: 'Ubicación',
            icon: Icons.location_on,
            children: [
              _summaryRow(
                'Estado',
                _ubicacionConfirmada
                    ? 'Ubicación confirmada ✓'
                    : 'Pendiente',
              ),
              if (_coordenadasConfirmadas != null) ...[
                _summaryRow('Latitud',
                    _coordenadasConfirmadas!.latitude.toStringAsFixed(6)),
                _summaryRow('Longitud',
                    _coordenadasConfirmadas!.longitude.toStringAsFixed(6)),
              ],
            ],
          ),

          const SizedBox(height: 30),

          // ------------------------------------------------------
          // ENVIAR
          // ------------------------------------------------------

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _enviarReporte,
              icon: const Icon(Icons.send),
              label: const Text(
                'Enviar reporte',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF145A32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Al enviar el reporte se generará un folio único.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // TÍTULO DE PREGUNTA
  // ============================================================

  Widget _questionTitle(
    String title, {
    required bool required,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        if (required)
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // TARJETA DE SELECCIÓN
  // ============================================================

  Widget _selectionCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE8F5E9)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF145A32)
                  : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? const Color(0xFF145A32)
                    : Colors.grey.shade700,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),

              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? const Color(0xFF145A32)
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTÓN DE EVIDENCIA
  // ============================================================

  Widget _evidenceButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool added,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: added
              ? const Color(0xFFE8F5E9)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: added
                ? const Color(0xFF2E7D32)
                : Colors.grey.shade300,
            width: added ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                added ? Icons.check : icon,
                color: added
                    ? const Color(0xFF2E7D32)
                    : color,
                size: 28,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF145A32),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TARJETA DE RESUMEN
  // ============================================================

  Widget _summaryCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF145A32),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Divider(
            height: 25,
          ),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // FILA DEL RESUMEN
  // ============================================================

  Widget _summaryRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTONES INFERIORES
  // ============================================================

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ------------------------------------------------------
          // ATRÁS
          // ------------------------------------------------------

          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _pasoAnterior,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF145A32),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Atrás',
                ),
              ),
            ),

          if (_currentStep > 0)
            const SizedBox(width: 12),

          // ------------------------------------------------------
          // CONTINUAR
          // ------------------------------------------------------

          Expanded(
            child: ElevatedButton(
              onPressed: _siguientePaso,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF145A32),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _currentStep == 2
                    ? 'Revisar reporte'
                    : 'Continuar',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
