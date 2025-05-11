import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
    final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
    final _telefonocontroller = TextEditingController();
    final _direccioncontroller = TextEditingController();

  final _passwordController = TextEditingController();
  final _repeatpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,

      body: Center(  // Centra todo el contenido
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,  // Centra horizontalmente
            children: [
              SizedBox(height: 10),
              // Campo de Nombres
              TextField(
                controller: _nombresController,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Apellidos
              TextField(
                controller: _apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Teléfono
              TextField(
                controller: _telefonocontroller,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                     filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Dirección
              TextField(
                controller: _direccioncontroller,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 20),
              // Campo de Repetir Contraseña
              TextField(
                controller: _repeatpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                                      filled: true,  // Habilita el color de fondo
    fillColor: Colors.grey.shade200,  // Cambia el color de fondo aquí
                ),
              ),
              SizedBox(height: 60),
              // Botón de Registrarse
              SizedBox(
                width: double.infinity,  // Hace que el botón ocupe todo el ancho de la pantalla
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "user_imc_goal",
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF226980), // Color de fondo del botón
                    padding: EdgeInsets.symmetric(vertical: 15), // Solo ajustamos el padding vertical
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados más suaves
                    ),
                    elevation: 5, // Sombra para dar un efecto más realista
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
