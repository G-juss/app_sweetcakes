import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/postre.dart';
import '../services/firestore_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final FirestoreService _service = FirestoreService();
  bool _checkingRole = true;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  // 🔐 GUARD ADMIN
  Future<void> _checkAdminRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = (doc.data()?['role'] ?? 'user').toString().toLowerCase();

      if (role != 'admin') {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      if (!mounted) return;
      setState(() => _checkingRole = false);
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingRole) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF0F5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF80AB)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () => _mostrarDialogoProducto(context, null),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF80AB),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ],
                ),
                child: const Center(
                  child: Text(
                    '+   Agregar Producto',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Postre>>(
              stream: _service.getProductos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFFF80AB)),
                  );
                }

                final productos = snapshot.data!;
                if (productos.isEmpty) {
                  return const Center(
                      child: Text('No hay productos. ¡Agrega uno!'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final prod = productos[index];
                    return ListTile(
                      title: Text(prod.nombre),
                      subtitle: Text('\$${prod.precio} | Stock: ${prod.stock}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _service.deleteProducto(prod.id!),
                      ),
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

  void _mostrarDialogoProducto(BuildContext context, Postre? producto) {}
}
