import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  String? _error;

  void _submit() {
    final firstName = _firstNameController.text.trim();
    final lastName  = _lastNameController.text.trim();
    final email     = _emailController.text.trim();
    final pass      = _passwordController.text;
    final repeat    = _repeatPasswordController.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || pass.isEmpty || repeat.isEmpty) {
      setState(() => _error = 'Por favor completa todos los campos');
      return;
    }
    if (pass != repeat) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() => _error = null);

    final registrationData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': pass,
    };

    Navigator.of(context).pushNamed(
      'user_imc_goal',
      arguments: registrationData,
    );
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
              SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _repeatPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              if (_error != null) ...[
                SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,  
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF226980),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
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
            ],
          ),
        ),
      ),
    );
  }
}