import 'package:flutter/material.dart';
import '../../constants.dart';
import 'ac_pasocuatro.dart';

class ScheduleAppointmentStep3Screen extends StatefulWidget {
  // Recibimos los datos acumulados de los pasos anteriores
  final Map<String, String> serviceData;
  final Map<String, String> dentistData;

  const ScheduleAppointmentStep3Screen({
    super.key,
    required this.serviceData,
    required this.dentistData,
  });

  @override
  State<ScheduleAppointmentStep3Screen> createState() =>
      _ScheduleAppointmentStep3ScreenState();
}

class _ScheduleAppointmentStep3ScreenState
    extends State<ScheduleAppointmentStep3Screen> {
  // Variables de estado
  late DateTime _selectedDate;
  String? _selectedTime;
  List<String> _availableTimes = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateAvailableTimes(_selectedDate);
  }

  // Lógica simulada de horarios (por el momento a falta de base de datos)
  void _updateAvailableTimes(DateTime date) {
    setState(() {
      _selectedTime = null;
      if (date.weekday == 6 || date.weekday == 7) {
        _availableTimes = ['09:00 AM', '10:00 AM', '11:00 AM'];
      } else if (date.day % 2 == 0) {
        _availableTimes = [
          '09:00 AM',
          '10:30 AM',
          '11:00 AM',
          '04:00 PM',
          '05:30 PM',
        ];
      } else {
        _availableTimes = [
          '08:30 AM',
          '09:30 AM',
          '12:00 PM',
          '02:30 PM',
          '03:30 PM',
          '04:30 PM',
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

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
                      'Paso 3 de 4',
                      style: TextStyle(color: kTextGrayColor, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elige fecha y hora',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Calendario  ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: ThemeData(
                          colorScheme: const ColorScheme.light(
                            primary: kPrimaryColor,
                            onPrimary: Colors.white,
                            surface: Colors.transparent,
                            onSurface: kLogoGrayColor,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                            ),
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: _selectedDate,
                          firstDate: today,
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          onDateChanged: (newDate) {
                            setState(() {
                              _selectedDate = newDate;
                              _updateAvailableTimes(newDate);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- Horarios Disponibles ---
                    const Text(
                      'Horarios disponibles',
                      style: TextStyle(
                        color: kLogoGrayColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _availableTimes.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay horarios para este día",
                              style: TextStyle(color: kTextGrayColor),
                            ),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _availableTimes.map((time) {
                              return _buildTimeChip(time);
                            }).toList(),
                          ),
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
                  onPressed: _selectedTime == null
                      ? null
                      : () {
                          // Pasamos a la pantalla de Confirmación (Paso 4)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppointmentConfirmationScreen(
                                    serviceData: widget.serviceData,
                                    dentistData: widget.dentistData,
                                    selectedDate: _selectedDate,
                                    selectedTime: _selectedTime!,
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

  Widget _buildTimeChip(String time) {
    final bool isSelected = _selectedTime == time;
    final Color backgroundColor = isSelected ? kPrimaryColor : Colors.white;
    final Color textColor = isSelected ? Colors.white : kLogoGrayColor;
    final Color borderColor = isSelected ? kPrimaryColor : kBorderGrayColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          time,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
