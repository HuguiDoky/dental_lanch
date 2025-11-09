import 'package:flutter/material.dart';
import 'presentacion/pantallas/login_screen.dart';
import 'presentacion/pantallas/register_type.dart';
import 'constants.dart';

void main() {
  runApp(
    const MyApp(),
  ); // Función principal que ejecuta la aplicación llamando al widget MyApp.
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  }); // Constructor constante para optimizar el rendimiento.

  @override
  Widget build(BuildContext context) {
    // build() define cómo se construye la interfaz visual del widget.
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Quita la etiqueta de "debug" en la esquina.
      title: 'Dental Lanch', // Título de la app.
      theme: ThemeData(primarySwatch: Colors.pink),
      home:
          const WelcomeScreen(), // Pantalla principal que se mostrará al iniciar la app.
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}); // Constructor del widget de la pantalla.

  @override
  Widget build(BuildContext context) {
    //Obtenemos el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SafeArea evita que el contenido se superponga con la barra de estado o notch.
        // SingleChildScrollView para evitar overflow en pantallas pequeñas
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            // Aseguramos la altura mínima para centrar verticalmente
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(
                    context,
                  ).padding.top, // Restamos el padding superior
            ),
            child: Column(
              // Organiza los elementos en una columna (de arriba hacia abajo).
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra verticalmente los widgets.
              children: [
                // === LOGO ===
                Image.asset(
                  'assets/logo.png', // Ruta del logo.
                  height: 160,
                ),

                const SizedBox(
                  height: 20,
                ), // Espacio vertical entre logo y texto.

                const SizedBox(height: 10),

                // === LEMA ===
                const Text(
                  'Tu sonrisa, nuestra pasión',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // === TEXTO PEQUEÑO DE OPCIÓN ===
                const Text(
                  'Puedes Iniciar Sesión\no\nCrear una cuenta con tu correo electrónico',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kTextGrayColor, fontSize: 15),
                ),

                const SizedBox(height: 40),

                // === BOTÓN "INICIAR SESIÓN" ===
                SizedBox(
                  width: double.infinity, // Ancho adaptable
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // <<< navega a la pantalla de Login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Bordes redondeados.
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // === BOTÓN "CREAR CUENTA" ===
                SizedBox(
                  width: double.infinity, // Ancho adaptable
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegamos a la nueva pantalla
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterTypeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBorderGrayColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
