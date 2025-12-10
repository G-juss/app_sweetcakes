import 'package:flutter/material.dart';
import '../models/postre.dart';

class PostreCard extends StatelessWidget {
  final Postre postre;
  final VoidCallback onAgregar;

  const PostreCard({required this.postre, required this.onAgregar});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(postre.imagenUrl, height: 100, fit: BoxFit.cover),
          Text(postre.nombre, style: TextStyle(fontSize: 16)),
          Text('\$${postre.precio}', style: TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: onAgregar, child: Text('+ Agregar')),
        ],
      ),
    );
  }
}
