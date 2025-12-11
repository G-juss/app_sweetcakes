import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomSignInScreen extends StatefulWidget {
  const CustomSignInScreen({super.key});

  @override
  State<CustomSignInScreen> createState() => _CustomSignInScreenState();
}

class _CustomSignInScreenState extends State<CustomSignInScreen> {
  // Controladores para leer el texto de los inputs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Variable para mostrar un indicador de carga mientras inicia sesión
  bool _isLoading = false;
  // Variable para ocultar/mostrar la contraseña
  bool _isPasswordVisible = false;

  // Función para procesar el Login
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa correo y contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Intento de inicio de sesión con Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Si tiene éxito, navegamos al Home
      if (mounted) {
       Navigator.of(context).pushReplacementNamed('/home');
      }
      
    } on FirebaseAuthException catch (e) {
      // Manejo de errores comunes en español
      String errorMessage = 'Ocurrió un error al iniciar sesión';
      if (e.code == 'user-not-found') {
        errorMessage = 'No existe un usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'El formato del correo no es válido.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Demasiados intentos fallidos. Intenta más tarde.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Esta cuenta ha sido deshabilitada.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Scaffold blanco como en el diseño
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. IMAGEN SUPERIOR REDONDA
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5), // Fondo rosa pálido
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    // Puedes cambiar esta URL por una local: AssetImage('assets/images/logo.png')
                    image: NetworkImage('https://cdn-icons-png.flaticon.com/512/2682/2682455.png'),
                    fit: BoxFit.scaleDown,
                    scale: 0.8
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 2. TEXTOS DE BIENVENIDA (TRADUCIDOS)
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión en tu cuenta',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // 3. CAMPOS DE TEXTO (INPUTS TRADUCIDOS)
              // Campo de Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration('Correo electrónico', Icons.email_outlined),
              ),
              const SizedBox(height: 20),
              
              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Oculta el texto
                decoration: _buildInputDecoration('Contraseña', Icons.lock_outline).copyWith(
                  // Icono para mostrar/ocultar contraseña
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 4. BOTÓN "OLVIDÉ CONTRASEÑA" (Alineado a la derecha)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad de recuperar contraseña próximamente')),
                      );
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Color(0xFFFF80AB), // Rosa principal
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 5. BOTÓN PRINCIPAL "INICIAR SESIÓN"
              SizedBox(
                width: double.infinity, // Ancho completo
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login, // Deshabilita si está cargando
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF80AB), // Rosa principal
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bordes muy redondos
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),

              // 6. TEXTO DE REGISTRO ABAJO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes cuenta? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ir a pantalla de Registro')),
                      );
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Color(0xFFFF80AB), // Rosa principal
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para el estilo de los inputs (mismo diseño, reutilizable)
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white, // Fondo blanco
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      // Borde cuando el campo está habilitado pero no enfocado
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFFE4E1), width: 1.5),
      ),
      // Borde cuando el usuario está escribiendo
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFF80AB), width: 2),
      ),
      // Borde para errores
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}