import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(  // Centra el contenido
        child: SingleChildScrollView(  // Envuelve el contenido en un SingleChildScrollView
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,  // Centra horizontalmente
            children: [
              Text(
          'Bienvenido!',
          style: TextStyle(
            fontSize: 26, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita
          ),
        ),
              Text(
                'Inicia Sesión para Continuar',
                style: TextStyle(
                  fontSize: 16, // Tamaño pequeño
                  fontWeight: FontWeight.w400, // No tan pesado como el título
                  color: Colors.grey[700], // Gris suave
                ),
              ),
              SizedBox(height: 80),
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
                mainAxisAlignment: MainAxisAlignment.start,  // Alineación a la izquierda
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
              SizedBox(
                width: double.infinity, // Hace que el botón ocupe todo el ancho de la pantalla
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "progress",
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
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF2D2D2D), // Color de la línea (gris claro)
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
                      color: Color(0xFF2D2D2D), // Color de la línea
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
                      width: 40,  // Ajusta el tamaño del icono
                      height: 40, // Ajusta el tamaño del icono
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
              SizedBox(height: 60),
              // Enlace para registro
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("register");
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
      ),
    );
  }
}
