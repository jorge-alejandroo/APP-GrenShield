import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/report_location_picker.dart';

class FireReportScreen extends StatefulWidget {
  const FireReportScreen({super.key});

  @override
  State<FireReportScreen> createState() => _FireReportScreenState();
}

class _FireReportScreenState extends State<FireReportScreen> {
  // ============================================================
  // PASOS DEL REPORTE
  // ============================================================
  //
  // 0 = Información del incendio
  // 1 = Evidencia
  // 2 = Ubicación
  // 3 = Confirmación
  //
  // Más adelante podemos agregar o quitar pasos si el proyecto
  // cambia.
  // ============================================================

  int _currentStep = 0;

  // ============================================================
  // RESPUESTAS DEL CUESTIONARIO
  // ============================================================

  String? _tipoIncendio;
  String? _estadoIncendio;
  String? _queObserva;
  String? _riesgo;

  // Descripción escrita por el usuario.
  final TextEditingController _descripcionController =
      TextEditingController();

  // ============================================================
  // EVIDENCIAS
  // ============================================================
  //
  // Por ahora solamente guardamos indicadores para representar
  // las evidencias agregadas.
  //
  // Más adelante estos valores serán reemplazados por archivos
  // reales obtenidos mediante cámara, galería y grabadora.
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
  // CONTROLADORES
  // ============================================================

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _descripcionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // AVANZAR AL SIGUIENTE PASO
  // ============================================================

  void _siguientePaso() {
    // Validamos cada sección antes de continuar.

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

    // Si todavía no estamos en el último paso,
    // avanzamos.
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
  // REGRESAR AL PASO ANTERIOR
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
    if (_tipoIncendio == null) {
      _mostrarMensaje(
        'Selecciona el tipo de incendio.',
      );
      return false;
    }

    if (_estadoIncendio == null) {
      _mostrarMensaje(
        'Indica si el incendio está activo.',
      );
      return false;
    }

    if (_queObserva == null) {
      _mostrarMensaje(
        'Indica qué observas.',
      );
      return false;
    }

    if (_riesgo == null) {
      _mostrarMensaje(
        'Indica si existe algún riesgo.',
      );
      return false;
    }

    return true;
  }

  // ============================================================
  // VALIDAR EVIDENCIA
  // ============================================================

  bool _validarEvidencia() {
    // Para que el reporte tenga evidencia, solicitamos al menos
    // una fotografía, video o audio.
    if (!_tieneFoto && !_tieneVideo && !_tieneAudio) {
      _mostrarMensaje(
        'Agrega al menos una evidencia: foto, video o audio.',
      );
      return false;
    }

    return true;
  }

  // ============================================================
  // MENSAJE TEMPORAL
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
  // AGREGAR FOTOGRAFÍA
  // ============================================================

  void _agregarFoto() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    //
    // Aquí posteriormente conectaremos:
    //
    // ImagePicker / cámara del dispositivo.
    //
    // Por ahora solamente simulamos que se agregó una foto.
    // ----------------------------------------------------------

    setState(() {
      _tieneFoto = true;
    });

    _mostrarMensaje(
      'Fotografía agregada correctamente.',
    );
  }

  // ============================================================
  // AGREGAR VIDEO
  // ============================================================

  void _agregarVideo() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    //
    // Aquí posteriormente conectaremos la cámara para grabar
    // o seleccionar un video.
    // ----------------------------------------------------------

    setState(() {
      _tieneVideo = true;
    });

    _mostrarMensaje(
      'Video agregado correctamente.',
    );
  }

  // ============================================================
  // AGREGAR AUDIO
  // ============================================================

  void _agregarAudio() {
    // ----------------------------------------------------------
    // TEMPORAL
    // ----------------------------------------------------------
    //
    // Aquí posteriormente conectaremos una grabadora de audio.
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
    // El folio definitivo deberá generarse en el servidor.
    //
    // Por ahora utilizamos un folio de demostración para poder
    // visualizar cómo funcionará la pantalla.
    // ----------------------------------------------------------

    const String folio = 'INC-2026-000001';

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
                'Tu reporte de incendio fue registrado '
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

                  // Regresamos al inicio.
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

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        title: const Text(
          'Reporte de incendio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: const Color(0xFF145A32),
        foregroundColor: Colors.white,

        // No mostramos botón de regreso en el último paso.
        automaticallyImplyLeading: _currentStep < 3,
      ),

      // ==========================================================
      // CONTENIDO
      // ==========================================================

      body: Column(
        children: [

          // ------------------------------------------------------
          // INDICADOR DE PROGRESO
          // ------------------------------------------------------

          _buildProgressIndicator(),

          // ------------------------------------------------------
          // PÁGINAS
          // ------------------------------------------------------

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

          // ------------------------------------------------------
          // BOTONES INFERIORES
          // ------------------------------------------------------

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
  // ELEMENTO DEL PROGRESO
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
  // LÍNEA DEL INDICADOR
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
            Icons.local_fire_department,
            size: 50,
            color: Color(0xFFD84315),
          ),

          const SizedBox(height: 10),

          const Text(
            'Información del incendio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Selecciona las opciones que describan '
            'mejor la situación.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // TIPO DE INCENDIO
          // ------------------------------------------------------

          _questionTitle(
            '¿Qué tipo de incendio observas?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Pastizal',
            icon: Icons.grass,
            selected: _tipoIncendio == 'Pastizal',
            onTap: () {
              setState(() {
                _tipoIncendio = 'Pastizal';
              });
            },
          ),

          _selectionCard(
            title: 'Forestal',
            icon: Icons.forest,
            selected: _tipoIncendio == 'Forestal',
            onTap: () {
              setState(() {
                _tipoIncendio = 'Forestal';
              });
            },
          ),

          _selectionCard(
            title: 'Basura',
            icon: Icons.delete_outline,
            selected: _tipoIncendio == 'Basura',
            onTap: () {
              setState(() {
                _tipoIncendio = 'Basura';
              });
            },
          ),

          _selectionCard(
            title: 'Otro',
            icon: Icons.help_outline,
            selected: _tipoIncendio == 'Otro',
            onTap: () {
              setState(() {
                _tipoIncendio = 'Otro';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // ESTADO
          // ------------------------------------------------------

          _questionTitle(
            '¿El incendio está activo actualmente?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Sí',
            icon: Icons.local_fire_department,
            selected: _estadoIncendio == 'Sí',
            onTap: () {
              setState(() {
                _estadoIncendio = 'Sí';
              });
            },
          ),

          _selectionCard(
            title: 'No',
            icon: Icons.check_circle_outline,
            selected: _estadoIncendio == 'No',
            onTap: () {
              setState(() {
                _estadoIncendio = 'No';
              });
            },
          ),

          _selectionCard(
            title: 'No estoy seguro',
            icon: Icons.help_outline,
            selected: _estadoIncendio == 'No estoy seguro',
            onTap: () {
              setState(() {
                _estadoIncendio = 'No estoy seguro';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // QUÉ OBSERVA
          // ------------------------------------------------------

          _questionTitle(
            '¿Qué observas?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Humo',
            icon: Icons.cloud,
            selected: _queObserva == 'Humo',
            onTap: () {
              setState(() {
                _queObserva = 'Humo';
              });
            },
          ),

          _selectionCard(
            title: 'Fuego visible',
            icon: Icons.local_fire_department,
            selected: _queObserva == 'Fuego visible',
            onTap: () {
              setState(() {
                _queObserva = 'Fuego visible';
              });
            },
          ),

          _selectionCard(
            title: 'Humo y fuego',
            icon: Icons.warning_amber,
            selected: _queObserva == 'Humo y fuego',
            onTap: () {
              setState(() {
                _queObserva = 'Humo y fuego';
              });
            },
          ),

          _selectionCard(
            title: 'Solo indicios',
            icon: Icons.visibility_outlined,
            selected: _queObserva == 'Solo indicios',
            onTap: () {
              setState(() {
                _queObserva = 'Solo indicios';
              });
            },
          ),

          const SizedBox(height: 25),

          // ------------------------------------------------------
          // RIESGO
          // ------------------------------------------------------

          _questionTitle(
            '¿Hay personas, viviendas o vehículos en riesgo?',
            required: true,
          ),

          const SizedBox(height: 10),

          _selectionCard(
            title: 'Sí',
            icon: Icons.warning_amber,
            selected: _riesgo == 'Sí',
            onTap: () {
              setState(() {
                _riesgo = 'Sí';
              });
            },
          ),

          _selectionCard(
            title: 'No',
            icon: Icons.check_circle_outline,
            selected: _riesgo == 'No',
            onTap: () {
              setState(() {
                _riesgo = 'No';
              });
            },
          ),

          _selectionCard(
            title: 'No estoy seguro',
            icon: Icons.help_outline,
            selected: _riesgo == 'No estoy seguro',
            onTap: () {
              setState(() {
                _riesgo = 'No estoy seguro';
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

          // ------------------------------------------------------
          // FOTOGRAFÍA
          // ------------------------------------------------------

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

          // ------------------------------------------------------
          // VIDEO
          // ------------------------------------------------------

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

          // ------------------------------------------------------
          // AUDIO
          // ------------------------------------------------------

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

          // ------------------------------------------------------
          // AVISO
          // ------------------------------------------------------

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Icon(
                  Icons.info_outline,
                  color: Color(0xFFF57F17),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Agrega al menos una evidencia. No es necesario '
                    'agregar los tres tipos.',
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
            'Confirma en el mapa el lugar donde se encuentra el incendio.',
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
            title: 'Información del incendio',
            icon: Icons.local_fire_department,
            children: [
              _summaryRow(
                'Tipo',
                _tipoIncendio ?? 'No especificado',
              ),
              _summaryRow(
                'Estado',
                _estadoIncendio ?? 'No especificado',
              ),
              _summaryRow(
                'Observación',
                _queObserva ?? 'No especificado',
              ),
              _summaryRow(
                'Riesgo',
                _riesgo ?? 'No especificado',
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
          // EVIDENCIAS
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
          // BOTÓN ENVIAR
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
                backgroundColor: const Color(0xFF145A32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icon,
                color: const Color(0xFF145A32),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          // BOTÓN ATRÁS
          // ------------------------------------------------------

          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _pasoAnterior,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF145A32),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
          // BOTÓN CONTINUAR
          // ------------------------------------------------------

          Expanded(
            child: ElevatedButton(
              onPressed: _siguientePaso,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF145A32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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
