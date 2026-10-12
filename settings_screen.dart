import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // ============================================================
  // CONFIGURACIÓN DE IDIOMA
  // ============================================================
  //
  // Idioma seleccionado actualmente.
  //
  // IMPORTANTE:
  // Cuando conectemos el sistema de traducciones, esta variable
  // determinará el idioma de TODA la aplicación.
  //
  // Idiomas disponibles actualmente:
  // - Español
  // - English
  //
  // Si posteriormente queremos agregar otro idioma, solamente
  // tendremos que agregarlo a la lista y al sistema de traducción.
  // ============================================================

  String idiomaSeleccionado = 'Español';

  // ============================================================
  // NOTIFICACIONES
  // ============================================================
  //
  // Permite activar o desactivar las notificaciones.
  //
  // Posteriormente esta opción se puede conectar con Firebase
  // Cloud Messaging u otro servicio de notificaciones.
  // ============================================================

  bool notificaciones = true;

  // ============================================================
  // SONIDOS
  // ============================================================

  bool sonidos = true;

  // ============================================================
  // VIBRACIÓN
  // ============================================================
  //
  // Puede utilizarse para avisos importantes.
  // ============================================================

  bool vibracion = true;

  // ============================================================
  // MODO OSCURO
  // ============================================================
  //
  // Actualmente cambia solamente el estado visual de esta
  // configuración.
  //
  // Posteriormente lo conectaremos al ThemeMode de MaterialApp
  // para que toda la aplicación cambie automáticamente.
  // ============================================================

  bool modoOscuro = false;

  // ============================================================
  // TAMAÑO DEL TEXTO
  // ============================================================
  //
  // Este valor permitirá aumentar o disminuir el tamaño del texto.
  //
  // Más adelante podemos hacer que se aplique globalmente mediante
  // MediaQuery.textScaler o un sistema de accesibilidad.
  // ============================================================

  double tamanioTexto = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F5),
        elevation: 0,
        foregroundColor: const Color(0xFF145A32),
        title: const Text(
          'Configuración',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ======================================================
          // SECCIÓN: IDIOMA
          // ======================================================

          _tituloSeccion(
            'Idioma',
            Icons.language,
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.translate,
                color: Color(0xFF145A32),
              ),

              title: const Text(
                'Idioma de la aplicación',
              ),

              subtitle: Text(
                idiomaSeleccionado,
              ),

              trailing: DropdownButton<String>(
                value: idiomaSeleccionado,

                // ==================================================
                // PARA AGREGAR MÁS IDIOMAS:
                //
                // Agrega el nuevo idioma aquí.
                //
                // Ejemplo:
                // 'Francés',
                // 'Português',
                // ==================================================

                items: const [
                  DropdownMenuItem(
                    value: 'Español',
                    child: Text('Español'),
                  ),
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('English'),
                  ),
                ],

                onChanged: (valor) {
                  if (valor == null) return;

                  setState(() {
                    idiomaSeleccionado = valor;
                  });

                  // ==================================================
                  // IMPORTANTE:
                  //
                  // Aquí posteriormente conectaremos el sistema
                  // de traducciones de GreenShield.
                  //
                  // Actualmente solamente cambia el valor mostrado.
                  // ==================================================
                },
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SECCIÓN: NOTIFICACIONES
          // ======================================================

          _tituloSeccion(
            'Notificaciones',
            Icons.notifications_none,
          ),

          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_none,
                color: Color(0xFF145A32),
              ),

              title: const Text(
                'Recibir notificaciones',
              ),

              subtitle: const Text(
                'Avisos sobre tus reportes',
              ),

              value: notificaciones,

              onChanged: (valor) {
                setState(() {
                  notificaciones = valor;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SECCIÓN: SONIDO Y VIBRACIÓN
          // ======================================================

          _tituloSeccion(
            'Sonido y vibración',
            Icons.volume_up_outlined,
          ),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.volume_up_outlined,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Sonidos',
                  ),
                  subtitle: const Text(
                    'Reproducir sonidos de la aplicación',
                  ),
                  value: sonidos,
                  onChanged: (valor) {
                    setState(() {
                      sonidos = valor;
                    });
                  },
                ),

                const Divider(
                  height: 1,
                ),

                SwitchListTile(
                  secondary: const Icon(
                    Icons.vibration,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Vibración',
                  ),
                  subtitle: const Text(
                    'Vibrar para avisos importantes',
                  ),
                  value: vibracion,
                  onChanged: (valor) {
                    setState(() {
                      vibracion = valor;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SECCIÓN: APARIENCIA
          // ======================================================

          _tituloSeccion(
            'Apariencia',
            Icons.palette_outlined,
          ),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode_outlined,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Modo oscuro',
                  ),
                  subtitle: const Text(
                    'Cambiar la apariencia de la aplicación',
                  ),
                  value: modoOscuro,
                  onChanged: (valor) {
                    setState(() {
                      modoOscuro = valor;
                    });

                    // ==================================================
                    // POSTERIORMENTE:
                    //
                    // Aquí conectaremos esta variable con ThemeMode
                    // para que TODA la aplicación cambie.
                    // ==================================================
                  },
                ),

                const Divider(
                  height: 1,
                ),

                // ==================================================
                // TAMAÑO DEL TEXTO
                // ==================================================

                ListTile(
                  leading: const Icon(
                    Icons.text_fields,
                    color: Color(0xFF145A32),
                  ),

                  title: const Text(
                    'Tamaño del texto',
                  ),

                  subtitle: Slider(
                    min: 0.8,
                    max: 1.5,
                    divisions: 7,
                    value: tamanioTexto,
                    label:
                        '${(tamanioTexto * 100).round()}%',

                    onChanged: (valor) {
                      setState(() {
                        tamanioTexto = valor;
                      });

                      // ==================================================
                      // POSTERIORMENTE:
                      //
                      // Este valor se aplicará globalmente al texto
                      // de toda la aplicación.
                      // ==================================================
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SECCIÓN: PRIVACIDAD
          // ======================================================

          _tituloSeccion(
            'Privacidad y seguridad',
            Icons.security_outlined,
          ),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Privacidad',
                  ),
                  subtitle: const Text(
                    'Consulta cómo se utilizan tus datos',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _mensaje(
                      context,
                      'Pantalla de privacidad próximamente.',
                    );
                  },
                ),

                const Divider(
                  height: 1,
                ),

                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Seguridad',
                  ),
                  subtitle: const Text(
                    'Opciones de seguridad de tu cuenta',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _mensaje(
                      context,
                      'Opciones de seguridad próximamente.',
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // SECCIÓN: INFORMACIÓN
          // ======================================================

          _tituloSeccion(
            'Información',
            Icons.info_outline,
          ),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF145A32),
                  ),
                  title: const Text(
                    'Acerca de GreenShield',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _mostrarAcercaDe(context);
                  },
                ),

                const Divider(
                  height: 1,
                ),

                const ListTile(
                  leading: Icon(
                    Icons.apps,
                    color: Color(0xFF145A32),
                  ),
                  title: Text(
                    'Versión',
                  ),
                  subtitle: Text(
                    '1.0.0',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================================
  // TÍTULO DE SECCIÓN
  // ============================================================

  Widget _tituloSeccion(
    String titulo,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 5,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF145A32),
          ),

          const SizedBox(width: 8),

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF145A32),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENSAJE TEMPORAL
  // ============================================================

  void _mensaje(
    BuildContext context,
    String mensaje,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN DE GREENSHIELD
  // ============================================================

  void _mostrarAcercaDe(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'GreenShield',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'M.A.M.B.O. - Monitoreo Ambiental y Mapeo de Bosques Oportuno',
    );
  }
}