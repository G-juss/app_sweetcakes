import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  // Datos de prueba para simular el carrito visualmente
  final List<Map<String, dynamic>> cartItems = [
    {
      'nombre': 'Pastel de Chocolate',
      'precio': 450,
      'cantidad': 2,
      'imagen': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
    },
    {
      'nombre': 'Pastel de Fresa',
      'precio': 380,
      'cantidad': 1,
      'imagen': 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3',
    },
  ];

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculamos el total simulado
    double total = 0;
    for (var item in cartItems) {
      total += (item['precio'] as int) * (item['cantidad'] as int);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Fondo rosa pálido
      appBar: AppBar(
        title: const Text(
          'Mi Carrito',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF80AB)),
      ),
      body: Column(
        children: [
          // 1. LISTA DE PRODUCTOS (Expanded ocupa el espacio disponible)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Imagen del producto
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item['imagen'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.cake),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // Detalles del producto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nombre'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$${item['precio']} c/u',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Controles de cantidad (+ -)
                      Column(
                        children: [
                          Row(
                            children: [
                              // Botón Menos
                              _buildQuantityButton(Icons.remove, isPink: false),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${item['cantidad']}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              // Botón Más
                              _buildQuantityButton(Icons.add, isPink: true),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. SECCIÓN DE RESUMEN Y PAGO (Parte inferior)
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(0)}', 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF80AB))),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Botón Confirmar Pedido
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando pedido...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF80AB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Confirmar Pedido',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget auxiliar para los botones redondos de cantidad
  Widget _buildQuantityButton(IconData icon, {required bool isPink}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPink ? const Color(0xFFFF80AB) : const Color(0xFFFFEBF2), // Rosa fuerte o rosa claro
      ),
      child: Icon(
        icon,
        size: 18,
        color: isPink ? Colors.white : const Color(0xFFFF80AB),
      ),
    );
  }
}