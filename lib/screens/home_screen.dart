import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // Para el botón de salir si lo necesitas
import '../models/postre.dart';
import '../widgets/postre_card.dart';

class HomeScreen extends StatelessWidget {
  // Datos quemados para prueba
  final List<Postre> postres = [
    Postre(id: '1', nombre: 'Pastel de Chocolate', imagenUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587', precio: 450),
    Postre(id: '2', nombre: 'Pastel de Fresa', imagenUrl: 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3', precio: 380),
    Postre(id: '3', nombre: 'Pastel de Limón', imagenUrl: 'https://images.unsplash.com/photo-1519340333755-56e9c1d04579', precio: 280),
    Postre(id: '4', nombre: 'Cupcakes', imagenUrl: 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543', precio: 150),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SweetCakes',
          style: TextStyle(color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold),
        ),
        // Icono de carrito a la derecha
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFFF80AB)),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          // Botón temporal para cerrar sesión y probar login
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
        // Icono del menú (hamburguesa) a la izquierda con color personalizado
        iconTheme: const IconThemeData(color: Color(0xFFFF80AB)),
      ),
      
      // EL CUERPO DE LA PANTALLA
      body: Column(
        children: [
          // 1. BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar pastel...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // El estilo ya viene del Theme en main.dart
              ),
            ),
          ),

          // 2. GRILLA DE PRODUCTOS
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: postres.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                childAspectRatio: 0.65, // Proporción alto/ancho (ajusta esto si se ven cortadas)
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return PostreCard(
                  postre: postres[index],
                  onAgregar: () {
                    // Acción al agregar (aun no validado)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Agregaste ${postres[index].nombre}'),
                        backgroundColor: const Color(0xFFFF80AB),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // Mantenemos tu Drawer original
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFFF80AB)),
              child: Center(
                child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
            ListTile(title: const Text('Perfil'), onTap: () => Navigator.pushNamed(context, '/profile')),
            ListTile(title: const Text('Carrito'), onTap: () => Navigator.pushNamed(context, '/cart')),
          ],
        ),
      ),
    );
  }
}