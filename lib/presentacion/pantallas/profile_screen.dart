import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../main.dart';

// StatefulWidget para manejar la selección de los botones
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variable de estado para guardar el índice del botón presionado
  // 0 = Editar Perfil, 1 = Seguridad, 2 = Cerrar Sesión
  int? _selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // Usamos SingleChildScrollView para que se adapte
      // y permita scroll en pantallas pequeñas
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity, // Ocupa todo el ancho
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0, // Más padding vertical para centrar
            ),
            // Aseguramos una altura mínima para el contenido
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  kBottomNavigationBarHeight, // Restamos la barra de navegación
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centramos el contenido
              children: [
                // --- Título ---
                const Text(
                  'Mi Perfil',
                  style: TextStyle(
                    color: kLogoGrayColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // --- Círculo de Iniciales ---
                const CircleAvatar(
                  radius: 60, // Tamaño del círculo
                  backgroundColor: kPrimaryColor,
                  child: Text(
                    'HC',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Nombre de Usuario ---
                const Text(
                  'Hugo Castrejón',
                  style: TextStyle(
                    color: kLogoGrayColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Correo Electrónico ---
                const Text(
                  'castrejonsalgadohugo@gmail.com',
                  style: TextStyle(color: kTextGrayColor, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // --- Botones de Acción ---
                _buildProfileCard(
                  title: 'Editar Perfil',
                  icon: Icons.person_outline,
                  index: 0,
                  onTap: () {
                    // Navegar a la pantalla de Editar Perfil
                  },
                ),
                const SizedBox(height: 20),
                _buildProfileCard(
                  title: 'Seguridad',
                  icon: Icons.shield_outlined,
                  index: 1,
                  showArrow: true, // Mostramos flecha
                  onTap: () {
                    // Navegar a la pantalla de Seguridad
                  },
                ),
                const SizedBox(height: 20),
                _buildProfileCard(
                  title: 'Cerrar Sesión',
                  icon: Icons.logout,
                  index: 2,
                  isDestructive: true, // Color de texto rojo
                  onTap: () {
                    // Lógica para cerrar sesión
                    // Por ejemplo, navegar a WelcomeScreen y borrar la pila
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget helper para construir los botones de perfil
  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required int index,
    required VoidCallback onTap,
    bool showArrow = false, // Para mostrar la flecha a la derecha
    bool isDestructive = false, // Para el texto "Cerrar Sesión"
  }) {
    // Determinamos si esta tarjeta está seleccionada
    final bool isSelected = _selectedCardIndex == index;

    // Determinamos los colores basados en la selección
    final Color borderColor = isSelected ? kPrimaryColor : kBorderGrayColor;
    final Color iconColor = isSelected
        ? kPrimaryColor
        : (isDestructive ? kPrimaryColor : kLogoGrayColor);
    final Color textColor = isSelected
        ? kPrimaryColor
        : (isDestructive ? kPrimaryColor : kLogoGrayColor);

    return GestureDetector(
      onTap: () {
        // Actualizamos el estado al presionar
        setState(() {
          _selectedCardIndex = index;
        });
        // Ejecutamos la acción (navegación, etc.)
        onTap();
      },
      child: Container(
        width: double.infinity, // Ocupa todo el ancho
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icono y Texto
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Flecha (si se requiere)
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                color: isSelected ? kPrimaryColor : kBorderGrayColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
