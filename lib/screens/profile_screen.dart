import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario actual de Firebase
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Fondo rosa pálido
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF80AB)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. TARJETA DE INFORMACIÓN DEL USUARIO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Avatar Circular
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xFFFF80AB),
                    child: Text(
                      user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Datos del usuario (Flexible evita errores si el correo es largo)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hola,',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          user?.displayName ?? 'Cliente Frecuente',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        Text(
                          user?.email ?? 'Sin correo',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Icono de editar
                  IconButton(
                    onPressed: () {
                      // Aqui iria la logica para editar el perfil
                    },
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFFFF80AB)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 2. LISTA DE OPCIONES (MENU)
            _buildProfileOption(Icons.shopping_bag_outlined, 'Mis Pedidos', () {}),
            _buildProfileOption(Icons.location_on_outlined, 'Direcciones de Entrega', () {}),
            _buildProfileOption(Icons.favorite_border, 'Favoritos', () {}),
            _buildProfileOption(Icons.help_outline, 'Ayuda y Soporte', () {}),

            const SizedBox(height: 40),

            // 3. BOTÓN DE CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  // Lógica de cierre de sesión
                  await FirebaseAuth.instance.signOut();
                  // Redirigir al Login y borrar historial de navegación
                  Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent, // Texto rojo para indicar salida
                  elevation: 0,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear las opciones del menú rápidamente
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5), // Fondo rosita para el icono
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFFF80AB)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D2D2D)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}