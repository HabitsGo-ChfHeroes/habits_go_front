import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro',
          style: TextStyle(
            fontSize: 26, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        backgroundColor: Colors.white, // Azul
        centerTitle: true, // Centra el título
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en un SingleChildScrollView
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Nombres',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.email),
              ),
            ),
                        SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Telefono',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Direccion',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            // Campo de contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
SizedBox(height: 20),
            // Campo de contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Repetir contraseña',
                border: OutlineInputBorder(),
                //prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),            // Recuérdame y Olvidaste la Contraseña
            SizedBox(height: 20),
            // Botón de Iniciar Sesión
            Container(
              width:
                  double
                      .infinity, // Hace que el botón ocupe todo el ancho de la pantalla
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                    0xFF226980,
                  ), // Color de fondo del botón
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ), // Solo ajustamos el padding vertical
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Bordes redondeados más suaves
                  ),
                  elevation: 5, // Sombra para dar un efecto más realista
                ),
              ),
            ),
            SizedBox(height: 10),
            
          ],
        ),
      ),
    );
  }
}