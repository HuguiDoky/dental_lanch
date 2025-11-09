import 'package:flutter/material.dart';
import '../../constants.dart';
import 'dentist_registration.dart';
import 'pacient_registration.dart';

// StatefulWidget para manejar la selección
class RegisterTypeScreen extends StatefulWidget {
  const RegisterTypeScreen({super.key});

  @override
  State<RegisterTypeScreen> createState() => _RegisterTypeScreenState();
}

class _RegisterTypeScreenState extends State<RegisterTypeScreen> {
  // Variable de estado para guardar la selección (0 = Paciente, 1 = Odontólogo)
  int? _selectedAccountType;

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
        // Título con dos colores usando RichText
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(
                text: 'Únete a ',
                style: TextStyle(color: kLogoGrayColor),
              ),
              TextSpan(
                text: 'Dental Lanch',
                style: TextStyle(color: kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        // Usamos SingleChildScrollView para que el contenido fluya
        // y permita scroll si es necesario
        child: SingleChildScrollView(
          child: Container(
            // Añadimos padding vertical y horizontal
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtítulo
                const Text(
                  'Para comenzar, dinos qué tipo de cuenta necesitas',
                  // --- CORRECCIÓN ---
                  style: TextStyle(color: kTextGrayColor, fontSize: 20),
                ),

                // Espacio entre el texto y la primera tarjeta
                const SizedBox(height: 40),

                // Card "Soy Paciente"
                _buildAccountTypeCard(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Soy Paciente',
                  subtitle:
                      'Busca y agenda citas con los mejores especialistas.',
                  index: 0,
                  onTap: () {
                    // <<< Navegamos a la pantalla de registro de paciente >>>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPatientScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Card "Soy Odontólogo"
                _buildAccountTypeCard(
                  context: context,
                  icon: Icons.medical_services_outlined,
                  title: 'Soy Odontólogo',
                  subtitle: 'Gestiona tus citas y pacientes de forma sencilla.',
                  index: 1,
                  onTap: () {
                    // <<< Navegamos a la pantalla de registro de odontólogo >>>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterDentistScreen(),
                      ),
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

  // Widget helper para construir las tarjetas de selección de cuenta
  Widget _buildAccountTypeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedAccountType == index;
    final Color iconColor = isSelected ? kPrimaryColor : kLogoGrayColor;
    final Color borderColor = isSelected ? kPrimaryColor : kBorderGrayColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAccountType = index;
        });
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kLogoGrayColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: kTextGrayColor),
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
