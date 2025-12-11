import 'package:flutter/material.dart';
import '../models/postre.dart';

class PostreCard extends StatelessWidget {
  final Postre postre;
  final VoidCallback onAgregar;

  const PostreCard({super.key, required this.postre, required this.onAgregar});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margen para separar las tarjetas
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. IMAGEN (Con esquinas redondeadas solo arriba)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              postre.imagenUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              // Muestra un icono si la imagen falla o carga
              errorBuilder: (context, error, stackTrace) => 
                  const Center(child: Icon(Icons.cake, size: 50, color: Colors.grey)),
            ),
          ),
          
          // 2. DETALLES
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del Pastel
                Text(
                  postre.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Precio
                Text(
                  '\$${postre.precio}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF80AB), // El rosa de tu diseño
                  ),
                ),
                const SizedBox(height: 10),
                // Botón Agregar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAgregar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9EBC), // Rosa pastel botón
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('+ Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}