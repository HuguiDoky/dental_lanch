import 'package:flutter/material.dart';
import '../../constants.dart';

class AppointmentsScreen extends StatelessWidget {
  // Recibimos la lista de citas desde el Home
  final List<Map<String, String>> appointments;

  const AppointmentsScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Se quita la flecha de atrás porque es una pestaña principal
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Mis Citas',
            style: TextStyle(
              color: kLogoGrayColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Aquí se podrá agregar las pestañas "Próximas" y "Pasadas" en el futuro
            const SizedBox(height: 10),

            Expanded(
              child: appointments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10.0,
                      ),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final app = appointments[index];
                        return _buildAppointmentCard(app);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Diseño cuando no hay citas
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            // ignore: deprecated_member_use
            size: 80,
            // ignore: deprecated_member_use
            color: kBorderGrayColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aún no tienes citas',
            style: TextStyle(
              color: kTextGrayColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de cada cita individual
  Widget _buildAppointmentCard(Map<String, String> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: kBorderGrayColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del tratamiento
          Text(
            appointment['treatment']!,
            style: const TextStyle(
              color: kLogoGrayColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Nombre del doctor
          Text(
            appointment['doctor']!,
            style: const TextStyle(color: kTextGrayColor, fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: kBorderGrayColor),
          const SizedBox(height: 12),
          // Fecha y Hora
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18, color: kPrimaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  appointment['date']!,
                  style: const TextStyle(
                    color: kLogoGrayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botones de acción (Simulados)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reagendar',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: kTextGrayColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
