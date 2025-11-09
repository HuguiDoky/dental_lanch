import 'package:flutter/material.dart';
import '../../constants.dart';
import 'profile_screen.dart';

// --- Constantes de la Barra de Navegación ---
const int kHomePageIndex = 0;
const int kCalendarPageIndex = 1;
const int kNotificationsPageIndex = 2;
const int kProfilePageIndex = 3;
const double kBottomNavigationBarHeight = 80.0; // Altura estimada

// Convertimos HomeScreen en un StatefulWidget para manejar el estado de la navegación
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable de estado para saber qué pestaña está seleccionada
  int _currentPageIndex = kHomePageIndex;

  // Controlador para las páginas (vistas)
  final PageController _pageController = PageController();

  // <<< Lista de las pantallas que se mostrarán >>>
  // Estas son las 4 "pestañas" de tu app
  final List<Widget> _widgetOptions = <Widget>[
    const _HomeScreenContent(), // El dashboard
    const Center(
      child: Text(
        'Mis Citas',
        style: TextStyle(fontSize: 24, color: kLogoGrayColor),
      ),
    ),
    const Center(
      child: Text(
        'Notificaciones',
        style: TextStyle(fontSize: 24, color: kLogoGrayColor),
      ),
    ),
    const ProfileScreen(), // <<< La pantalla de perfil
  ];

  // --- Función para manejar el toque en la barra de navegación ---
  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    // la página cambie con una animación suave
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // --- Función para navegar a la página de perfil desde el dashboard ---
  // Esta función se pasará al widget _HomeScreenContent
  void _navigateToProfile() {
    _onItemTapped(kProfilePageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Usamos PageView para poder deslizar entre pantallas
      // y controlarlo con la barra de navegación
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      // --- Añadimos la barra de navegación inferior ---
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icono relleno
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _currentPageIndex,
        selectedItemColor:
            kPrimaryColor, // Color rosa para el ítem seleccionado
        unselectedItemColor: kLogoGrayColor, // Color gris para los demás
        onTap: _onItemTapped, // Llama a nuestra función al presionar
        type: BottomNavigationBarType.fixed, // Mantiene los 4 ítems visibles
        showSelectedLabels: false, // Oculta etiquetas
        showUnselectedLabels: false,
        elevation: 10.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- Contenido del Dashboard ---
// -----------------------------------------------------------------
// Separamos el contenido de la "Home" en su propio widget
class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => __HomeScreenContentState();
}

class __HomeScreenContentState extends State<_HomeScreenContent> {
  // Estado para la tarjeta de navegación seleccionada
  int? _selectedCardIndex;
  // Estado para la campana de notificación
  bool _isNotificationActive = false;

  @override
  Widget build(BuildContext context) {
    // Buscamos la función _navigateToProfile del widget padre (HomeScreen)
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Encabezado ---
            _buildHeader(),
            const SizedBox(height: 30),

            // --- Tarjeta de Próxima Cita ---
            _buildNextAppointmentCard(),
            const SizedBox(height: 40),

            // --- ¿Qué necesitas hoy? ---
            const Text(
              '¿Qué necesitas hoy?',
              style: TextStyle(
                color: kLogoGrayColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- Botones de Navegación ---
            _buildNavigationCard(
              title: 'Agendar cita',
              icon: Icons.calendar_today_outlined,
              index: 0,
              onTap: () {
                // Navegar a la pantalla de Agendar Cita
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Mis citas',
              icon: Icons.list_alt_outlined, // Icono cambiado
              index: 1,
              onTap: () {
                // Navegar a la pantalla de Mis Citas
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Mi Perfil',
              icon: Icons.person_outline,
              index: 2,
              onTap: () {
                // <<< Llama a la función del widget padre >>>
                // Esto cambiará la pestaña de la barra de navegación
                homeScreenState?._navigateToProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets Auxiliares (sin cambios) ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido,',
              style: TextStyle(color: kTextGrayColor, fontSize: 18),
            ),
            Text(
              'Hugo Castrejón',
              style: TextStyle(
                color: kLogoGrayColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 35,
          backgroundColor: kPrimaryColor,
          child: Text(
            'HC',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAppointmentCard() {
    // Color dinámico de la campana
    final Color bellColor = _isNotificationActive
        ? kPrimaryColor
        : kLogoGrayColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(color: kBorderGrayColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Próxima Cita',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Campana interactiva
              IconButton(
                icon: Icon(
                  _isNotificationActive
                      ? Icons.notifications
                      : Icons.notifications_none_outlined,
                  color: bellColor,
                ),
                onPressed: () {
                  setState(() {
                    _isNotificationActive = !_isNotificationActive;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Limpieza Dental',
            style: TextStyle(
              color: kLogoGrayColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Odont. Fernanda Lampart',
            style: TextStyle(color: kTextGrayColor, fontSize: 15),
          ),
          const SizedBox(height: 16),
          const Divider(color: kBorderGrayColor),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: kLogoGrayColor,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Martes, 21 de Oct. - 10:30 AM',
                style: TextStyle(
                  color: kLogoGrayColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedCardIndex == index;
    final Color borderColor = isSelected ? kPrimaryColor : kBorderGrayColor;
    final Color iconColor = isSelected ? kPrimaryColor : kLogoGrayColor;
    final Color arrowColor = isSelected ? kPrimaryColor : kBorderGrayColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardIndex = index;
        });
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: kLogoGrayColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: arrowColor, size: 18),
          ],
        ),
      ),
    );
  }
}
