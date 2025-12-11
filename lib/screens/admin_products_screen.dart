import 'package:flutter/material.dart';
import '../models/postre.dart';
import '../services/firestore_service.dart';

class AdminProductsScreen extends StatelessWidget {
  final FirestoreService _service = FirestoreService();

  AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Fondo rosa pálido
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
      ),
      body: Column(
        children: [
          // BOTÓN "AGREGAR PRODUCTO" (Estilo barra superior)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => _mostrarDialogoProducto(context, null),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF80AB), // Rosa fuerte
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                  ],
                ),
                child: const Center(
                  child: Text(
                    '+   Agregar Producto',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          // LISTA DE PRODUCTOS DESDE FIREBASE
          Expanded(
            child: StreamBuilder<List<Postre>>(
              stream: _service.getProductos(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF80AB)));
                
                final productos = snapshot.data!;
                
                if (productos.isEmpty) {
                  return const Center(child: Text('No hay productos. ¡Agrega uno!'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final prod = productos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        // Imagen pequeña
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            prod.imagenUrl, 
                            width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.cake)),
                          ),
                        ),
                        // Textos
                        title: Text(prod.nombre, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
                        subtitle: Row(
                          children: [
                            Text('\$${prod.precio.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFFF80AB), fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Text('Stock: ${prod.stock}', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        // Botones de Acción (Editar / Eliminar)
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(Icons.edit_outlined, const Color(0xFFFF9EBC), () => _mostrarDialogoProducto(context, prod)),
                            const SizedBox(width: 8),
                            _buildActionButton(Icons.delete_outline, const Color(0xFFFFCDD2), () => _confirmarEliminar(context, prod.id!)),
                          ],
                        ),
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

  // Widget auxiliar para los botones pequeños cuadrados
  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.redAccent.shade100 == color ? Colors.red : const Color(0xFFFF80AB), size: 20),
      ),
    );
  }

  // DIÁLOGO PARA AGREGAR / EDITAR (Formulario)
  void _mostrarDialogoProducto(BuildContext context, Postre? producto) {
    final nombreCtrl = TextEditingController(text: producto?.nombre);
    final precioCtrl = TextEditingController(text: producto != null ? producto.precio.toString() : '');
    final stockCtrl = TextEditingController(text: producto != null ? producto.stock.toString() : '');
    // URL por defecto si no hay imagen
    final imgCtrl = TextEditingController(text: producto?.imagenUrl ?? 'https://cdn-icons-png.flaticon.com/512/2682/2682455.png');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(producto == null ? 'Nuevo Producto' : 'Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nombreCtrl, 'Nombre del producto'),
              const SizedBox(height: 10),
              _buildTextField(precioCtrl, 'Precio', isNumber: true),
              const SizedBox(height: 10),
              _buildTextField(stockCtrl, 'Stock', isNumber: true),
              const SizedBox(height: 10),
              _buildTextField(imgCtrl, 'URL de Imagen'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.isEmpty || precioCtrl.text.isEmpty) return;

              final nuevoProd = Postre(
                id: producto?.id,
                nombre: nombreCtrl.text,
                precio: double.tryParse(precioCtrl.text) ?? 0,
                stock: int.tryParse(stockCtrl.text) ?? 0,
                imagenUrl: imgCtrl.text,
              );

              if (producto == null) {
                _service.addProducto(nuevoProd);
              } else {
                _service.updateProducto(nuevoProd);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF80AB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              _service.deleteProducto(id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}