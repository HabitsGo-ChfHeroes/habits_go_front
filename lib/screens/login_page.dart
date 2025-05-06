import 'package:flutter/material.dart';
import 'package:habits_go_front/screens/register_page.dart'; // Asegúrate de que la ruta sea correcta

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido!',
          style: TextStyle(
            fontSize: 26, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
        backgroundColor: Colors.white, // Azul
        centerTitle: true, // Centra el título
      ),
      body: SingleChildScrollView(  // Envuelve el contenido en un SingleChildScrollView
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Inicia Sesión para Continuar',
                style: TextStyle(
                  fontSize: 16, // Tamaño pequeño
                  fontWeight: FontWeight.w400, // No tan pesado como el título
                  color: Colors.grey[700], // Gris suave
                ),
              ),
            ),
            
            SizedBox(height: 60),
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
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
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 10),
            // Recuérdame y Olvidaste la Contraseña
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                Text(
                  'Recuérdame',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Negrita
                    color: Colors.black, // Color negro
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Olvidaste la Contraseña?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Negrita
                      color: Colors.black, // Color negro
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Botón de Iniciar Sesión
            Container(
              width: double.infinity, // Hace que el botón ocupe todo el ancho de la pantalla
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF226980), // Color de fondo del botón
                  padding: EdgeInsets.symmetric(vertical: 15), // Solo ajustamos el padding vertical
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados más suaves
                  ),
                  elevation: 5, // Sombra para dar un efecto más realista
                ),
              ),
            ),
            SizedBox(height: 60),
            Row(
  children: [
    Expanded(
      child: Divider(
        color: Colors.grey[400], // Color de la línea (gris claro)
        thickness: 1, // Grosor de la línea
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaciado entre las líneas
      child: Text(
        'Iniciar sesión con',
        style: TextStyle(
          fontSize: 16, // Tamaño de fuente
          color: Colors.grey[600], // Color gris suave
        ),
      ),
    ),
    Expanded(
      child: Divider(
        color: Colors.grey[400], // Color de la línea
        thickness: 1, // Grosor de la línea
      ),
    ),
  ],
),
            SizedBox(height: 10),
            // Iconos de inicio de sesión con Google, Facebook y Apple
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google icon
                IconButton(
                  icon: Image.asset(
                    'assets/google.png',
                    width: 35,  // Ajusta el tamaño del icono
                    height: 35, // Ajusta el tamaño del icono
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 30),
                // Facebook icon
                IconButton(
                  icon: Image.asset(
                    'assets/facebook.png',
                    width: 35,  // Ajusta el tamaño del icono
                    height: 35, // Ajusta el tamaño del icono
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 30),
                // Apple icon
                IconButton(
                  icon: Image.asset(
                    'assets/apple.png',
                    width: 35,  // Ajusta el tamaño del icono
                    height: 35, // Ajusta el tamaño del icono
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            // Enlace para registro
            Center(
  child: TextButton(
    onPressed: () {
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
    },
    child: RichText(
      text: TextSpan(
        text: 'Sin Cuenta? ', // Texto "Sin Cuenta?" en gris
        style: TextStyle(
          color: Colors.grey[600], // Gris
          fontSize: 16, // Tamaño de fuente adecuado
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Regístrate Aquí', // Parte en color azul
            style: TextStyle(
              color: Color(0xFF226980), // Color azul
              fontSize: 16, // Tamaño de fuente
              fontWeight: FontWeight.bold, // Negrita para resaltar
            ),
          ),
        ],
      ),
    ),
  ),
)

          ],
        ),
      ),
    );
  }
}