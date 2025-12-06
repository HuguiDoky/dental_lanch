import 'package:flutter/material.dart';
import '../../constants.dart';
// Se importan las pantallas conectadas
import 'profile_screen.dart';
import 'ac_pasouno.dart';
import 'citas.dart';

// --- Constantes de la Barra de Navegación ---
const int kHomePageIndex = 0;
const int kCalendarPageIndex = 1;
const int kNotificationsPageIndex = 2;
const int kProfilePageIndex = 3;
const double kBottomNavigationBarHeight = 80.0;

class HomeScreen extends StatefulWidget {
  // Parámetros para recibir datos de la confirmación
  final int initialIndex;
  final Map<String, String>? newAppointment;

  const HomeScreen({super.key, this.initialIndex = 0, this.newAppointment});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentPageIndex;
  final PageController _pageController = PageController();

  // Lista estática para guardar TODAS las citas en memoria
  static final List<Map<String, String>> _appointmentsQueue = [];

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialIndex;

    // Si se recibe una nueva cita, la agregamos a la lista
    if (widget.newAppointment != null) {
      _appointmentsQueue.add(widget.newAppointment!);

      // Se ordena la lista para que la fecha más cercana quede primero
      _appointmentsQueue.sort((a, b) {
        DateTime dateA = _parseDate(a['date']!);
        DateTime dateB = _parseDate(b['date']!);
        return dateA.compareTo(dateB);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentPageIndex);
      }
    });
  }

  // Helper para convertir el String de fecha en DateTime y poder comparar
  DateTime _parseDate(String dateStr) {
    try {
      String cleanDate = dateStr.split(', ')[1];
      List<String> parts = cleanDate.split(' - ');

      List<String> dateParts = parts[0].split(' ');
      int day = int.parse(dateParts[0]);
      String monthStr = dateParts[2];
      int year = int.parse(dateParts[3]);

      Map<String, int> months = {
        'Ene': 1,
        'Feb': 2,
        'Mar': 3,
        'Abr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Ago': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dic': 12,
      };
      int month = months[monthStr] ?? 1;

      List<String> timeParts = parts[1].split(' ');
      List<String> hm = timeParts[0].split(':');
      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);
      String period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return DateTime.now().add(const Duration(days: 3650));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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
    // Obtenemos la cita más próxima (la primera de la lista ordenada)
    final nextApp = _appointmentsQueue.isNotEmpty
        ? _appointmentsQueue.first
        : null;

    final List<Widget> widgetOptions = <Widget>[
      // Pestaña 0: Home (Dashboard)
      _HomeScreenContent(appointment: nextApp),

      // Pestaña 1: Mis Citas
      AppointmentsScreen(appointments: _appointmentsQueue),

      // Pestaña 2: Notificaciones
      const Center(
        child: Text(
          'Notificaciones',
          style: TextStyle(fontSize: 24, color: kLogoGrayColor),
        ),
      ),

      // Pestaña 3: Perfil
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
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
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kLogoGrayColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}

// -----------------------------------------------------------------
// --- Contenido del Dashboard (Widget Interno) ---
// -----------------------------------------------------------------
class _HomeScreenContent extends StatefulWidget {
  // Recibimos la cita opcional (la más próxima)
  final Map<String, String>? appointment;

  const _HomeScreenContent({this.appointment});

  @override
  State<_HomeScreenContent> createState() => __HomeScreenContentState();
}

class __HomeScreenContentState extends State<_HomeScreenContent> {
  int? _selectedCardIndex;
  bool _isNotificationActive = false;

  @override
  Widget build(BuildContext context) {
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    // Usamos directamente la cita que nos pasa el padre
    final nextAppointment = widget.appointment;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            // Se pasa la cita al widget de la tarjeta
            _buildNextAppointmentCard(nextAppointment),
            const SizedBox(height: 40),
            const Text(
              '¿Qué necesitas hoy?',
              style: TextStyle(
                color: kLogoGrayColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildNavigationCard(
              title: 'Agendar cita',
              icon: Icons.calendar_today_outlined,
              index: 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleAppointmentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Mis citas',
              icon: Icons.list_alt_outlined,
              index: 1,
              onTap: () {
                homeScreenState?._onItemTapped(kCalendarPageIndex);
              },
            ),
            const SizedBox(height: 16),
            _buildNavigationCard(
              title: 'Mi Perfil',
              icon: Icons.person_outline,
              index: 2,
              onTap: () {
                homeScreenState?._navigateToProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

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

  // Se modifica para recibir la cita como parámetro
  Widget _buildNextAppointmentCard(Map<String, String>? appointment) {
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

          // Lógica: Si no hay cita, mostrar estado vacío
          if (appointment == null) ...[
            const SizedBox(height: 20),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.event_note, color: kBorderGrayColor, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'No tienes citas programadas',
                    style: TextStyle(color: kTextGrayColor, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            // Si hay cita, mostrar los datos
            const SizedBox(height: 8),
            Text(
              appointment['treatment']!,
              style: const TextStyle(
                color: kLogoGrayColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              appointment['doctor']!,
              style: const TextStyle(color: kTextGrayColor, fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Divider(color: kBorderGrayColor),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: kLogoGrayColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    appointment['date']!,
                    style: const TextStyle(
                      color: kLogoGrayColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
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
