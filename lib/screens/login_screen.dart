import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  final _authService = AuthService();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
  
    // Validación de campos vacíos
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _error = 'Por favor ingresa email y contraseña';
      });
      return;
    }
  
    setState(() {
      _loading = true;
      _error = null;
    });
  
    try {
      final success = await _authService.login(email, pass);
      if (success) {
        Navigator.of(context).pushReplacementNamed("daily_plan");
      } else {
        setState(() {
          _error = 'Credenciales inválidas';
        });
      }
    } catch (e) {
      // Aquí puedes afinar según el tipo de error (SocketException, Timeout, etc.)
      setState(() {
        _error = 'Error de conexión. Intenta nuevamente.';
      });
    } finally {
      // Esto garantiza que el indicador de carga desaparezca siempre
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(  
        child: SingleChildScrollView(  
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [
              Text(
          'Bienvenido!',
          style: TextStyle(
            fontSize: 26, 
            fontWeight: FontWeight.bold, 
          ),
        ),
              Text(
                'Inicia Sesión para Continuar',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w400, 
                  color: Colors.grey[700], 
                ),
              ),
              SizedBox(height: 80),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
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
              if (_error != null) ...[
                SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,  
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
                      fontWeight: FontWeight.bold, 
                      color: Colors.black, 
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Olvidaste la Contraseña?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.black, 
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF226980), 
                    padding: EdgeInsets.symmetric(vertical: 15), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), 
                    ),
                    elevation: 5, 
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
                      color: Color(0xFF2D2D2D), 
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                    child: Text(
                      'Iniciar sesión con',
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFF2D2D2D), 
                      thickness: 1, 
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/google.png',
                      width: 35,  
                      height: 35, 
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Image.asset(
                      'assets/facebook.png',
                      width: 40,  
                      height: 40, 
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 30),
                  IconButton(
                    icon: Image.asset(
                      'assets/apple.png',
                      width: 35,  
                      height: 35, 
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 60),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("register");
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Sin Cuenta? ', 
                      style: TextStyle(
                        color: Colors.grey[600], 
                        fontSize: 16, 
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Regístrate Aquí', 
                          style: TextStyle(
                            color: Color(0xFF226980), 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
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
