import 'package:flutter/material.dart';
import '../../constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // Añadimos un AppBar para tener la flecha de "atrás" automáticamente
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Sin sombra
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kLogoGrayColor),
          onPressed: () =>
              Navigator.of(context).pop(), // Regresa a la pantalla anterior
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Permite hacer scroll si el contenido no cabe
          child: Container(
            // Añadimos padding horizontal
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            // Ajustamos la altura mínima
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight, // Restamos el appbar
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- INICIO: Logo ---
                Column(
                  children: [
                    Image.asset('assets/logo.png', height: 160),
                    const SizedBox(height: 20),
                  ],
                ),

                // --- FIN: Logo ---
                const SizedBox(height: 10),

                // Título
                const Text(
                  'Inicia Sesión con tu cuenta',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtítulo
                const Text(
                  'Ingresa tu correo electrónico para iniciar sesión en Dental Lanch',
                  style: TextStyle(color: kTextGrayColor, fontSize: 15),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Campo de Correo Electrónico
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    hintText: 'correoelectrónico@dominio.com',
                  ),
                ),

                const SizedBox(height: 20),

                // Campo de Contraseña
                TextFormField(
                  obscureText: !_isPasswordVisible, // Ocultar contraseña
                  decoration: _buildInputDecoration(
                    hintText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: kTextGrayColor,
                      ),
                      onPressed: () {
                        // Cambiar el estado para mostrar/ocultar contraseña
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Botón de Iniciar Sesión
                SizedBox(
                  width: double.infinity, // El botón ocupa todo el ancho
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementar lógica de inicio de sesión
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) =>
                            false, // Esto elimina todas las pantallas (Welcome, Login)
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0, // Sin sombra
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Enlace de "Olvidaste tu contraseña"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Olvidaste tu contraseña? ',
                      style: TextStyle(color: kTextGrayColor, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implementar lógica de olvido de contraseña
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Quitar padding
                        minimumSize: Size.zero, // Quitar tamaño mínimo
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Click aquí',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper para construir la decoración de los campos de texto
  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: kBorderGrayColor),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderGrayColor, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderGrayColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
    );
  }
}
