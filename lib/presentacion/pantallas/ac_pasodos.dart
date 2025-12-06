import 'package:flutter/material.dart';
import '../../constants.dart';
import 'ac_pasotres.dart';

class ScheduleAppointmentStep2Screen extends StatefulWidget {
  // Variable para recibir los datos del Paso 1
  final Map<String, String> serviceData;

  const ScheduleAppointmentStep2Screen({super.key, required this.serviceData});

  @override
  State<ScheduleAppointmentStep2Screen> createState() =>
      _ScheduleAppointmentStep2ScreenState();
}

class _ScheduleAppointmentStep2ScreenState
    extends State<ScheduleAppointmentStep2Screen> {
  // Índice del odontólogo seleccionado
  int? _selectedDentistIndex;

  // Lista de odontólogos simulada (por el momento a falta de base de datos)
  final List<Map<String, String>> _dentists = [
    {
      'name': 'Odont. Fernanda Lampart',
      'specialty': 'Especialista en Odontopediatría',
      'initials': 'FL',
    },
    {
      'name': 'Odont. Angel Rendon',
      'specialty': 'Especialista en Estética Dental',
      'initials': 'AR',
    },
    {
      'name': 'Odont. Ingrid Hernandez',
      'specialty': 'Especialista en Odontopediatría',
      'initials': 'IH',
    },
    {
      'name': 'Odont. Giovanni Soto',
      'specialty': 'Especialista en Periodoncia',
      'initials': 'GS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kLogoGrayColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Agendar Cita',
          style: TextStyle(
            color: kLogoGrayColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paso 2 de 4',
                      style: TextStyle(color: kTextGrayColor, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selecciona un Odontólogo',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Servicio: ${widget.serviceData['title']}',
                        style: const TextStyle(
                          color: kTextGrayColor,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lista de Odontólogos
                    ...List.generate(_dentists.length, (index) {
                      final dentist = _dentists[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildDentistCard(
                          name: dentist['name']!,
                          specialty: dentist['specialty']!,
                          initials: dentist['initials']!,
                          index: index,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Botón Siguiente
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedDentistIndex == null
                      ? null
                      : () {
                          // Capturamos el odontólogo seleccionado
                          final selectedDentist =
                              _dentists[_selectedDentistIndex!];

                          // Pasamos al Paso 3 enviando AMBOS datos
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScheduleAppointmentStep3Screen(
                                    serviceData:
                                        widget.serviceData, // Dato del Paso 1
                                    dentistData:
                                        selectedDentist, // Dato del Paso 2
                                  ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    // ignore: deprecated_member_use
                    disabledBackgroundColor: kBorderGrayColor.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDentistCard({
    required String name,
    required String specialty,
    required String initials,
    required int index,
  }) {
    final bool isSelected = _selectedDentistIndex == index;
    final Color borderColor = isSelected ? kPrimaryColor : kBorderGrayColor;
    final Color avatarColor =
        // ignore: deprecated_member_use
        isSelected ? kPrimaryColor : kLogoGrayColor.withOpacity(0.5);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDentistIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kLogoGrayColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: const TextStyle(fontSize: 15, color: kTextGrayColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
