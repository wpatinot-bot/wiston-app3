import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF1A237E)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.apps, color: Colors.white, size: 56),
            ),
            const SizedBox(height: 20),
            const Text(
              'App Gestión de Datos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _infoCard(
              icon: Icons.person,
              title: 'Desarrollador',
              content: 'Wiston Patiño',
            ),
            const SizedBox(height: 12),
            _infoCard(
              icon: Icons.code,
              title: 'Tecnología',
              content: 'Flutter 3.x + Shared Preferences',
            ),
            const SizedBox(height: 12),
            _infoCard(
              icon: Icons.storage,
              title: 'Almacenamiento',
              content:
                  'Datos persistidos localmente usando SharedPreferences de Flutter',
            ),
            const SizedBox(height: 12),
            _infoCard(
              icon: Icons.featured_play_list,
              title: 'Funcionalidades',
              content:
                  '• Login con validación\n• Sesión persistente\n• CRUD completo\n• Búsqueda y filtros\n• Menú lateral (Drawer)\n• Alertas y notificaciones',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF1565C0).withOpacity(0.2)),
              ),
              child: const Column(
                children: [
                  Text(
                    '✦ Creado por Wiston Patiño ✦',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Actividad - Desarrollo Flutter\n2024',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      {required IconData icon,
      required String title,
      required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF1565C0)),
        ),
        title:
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
