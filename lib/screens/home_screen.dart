import 'package:flutter/material.dart';
import '../models/postre.dart';
import '../widgets/postre_card.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SweetCakes',
          style: TextStyle(color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFF80AB)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFFF80AB)),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          // Barra de búsqueda (Visual)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar pastel...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),

          // CONEXIÓN A FIREBASE
          Expanded(
            child: StreamBuilder<List<Postre>>(
              stream: _firestoreService.getProductos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF80AB)),
                  );
                }

                final postres = snapshot.data ?? [];

                // DEBUG (si lo ocupas, descomenta)
                // debugPrint('HOME productos: ${postres.length}');
                // for (final p in postres) {
                //   debugPrint('HOME -> ${p.nombre} | ${p.id}');
                // }

                if (postres.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cookie_outlined, size: 60, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text('El catálogo está vacío'),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/admin-products'),
                          child: const Text(
                            'Ir a Gestión de Productos',
                            style: TextStyle(color: Color(0xFFFF80AB)),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ Grid sin “vacío” en pantallas grandes (Chrome/web)
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width > 1200 ? 4 : width > 900 ? 3 : 2;

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: postres.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisExtent: 260, // ✅ altura fija (ajusta 240-300 si quieres)
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final postre = postres[index];

                        return PostreCard(
                          postre: postre,
                          onAgregar: () async {
                            try {
                              await _firestoreService.agregarAlCarrito(postre);

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('¡${postre.nombre} agregado al carrito! ✅'),
                                  backgroundColor: const Color(0xFFFF80AB),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al agregar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFF80AB)),
            child: Center(
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Carrito'),
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFFFF80AB)),
            title: const Text(
              'Gestión de Productos',
              style: TextStyle(
                color: Color(0xFFFF80AB),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/admin-products'),
          ),
        ],
      ),
    );
  }
}
