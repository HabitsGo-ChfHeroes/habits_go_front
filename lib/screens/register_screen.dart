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

      body: Center(  
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              SizedBox(height: 10),
              TextField(
                controller: _nombresController,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(),
                                      filled: true, 
    fillColor: Colors.grey.shade200, 
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                                      filled: true, 
    fillColor: Colors.grey.shade200,  
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                                      filled: true, 
    fillColor: Colors.grey.shade200,  
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _telefonocontroller,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                     filled: true,  
    fillColor: Colors.grey.shade200, 
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _direccioncontroller,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                                      filled: true,  
    fillColor: Colors.grey.shade200,  
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              TextField(
                controller: _repeatpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                                      filled: true,  
    fillColor: Colors.grey.shade200,  
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                width: double.infinity,  
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "user_imc_goal",
                      (Route<dynamic> route) => false,
                    );
                  },
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
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
