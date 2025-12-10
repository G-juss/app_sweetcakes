import 'package:flutter/material.dart';
import '../models/postre.dart';
import '../widgets/postre_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Postre> postres = [
    Postre(id: '1', nombre: 'Pastel de Chocolate', imagenUrl: 'https://...', precio: 450),
    Postre(id: '2', nombre: 'Pastel de Fresa', imagenUrl: 'https://...', precio: 380),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Postres')),
      body: GridView.builder(
        itemCount: postres.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return PostreCard(
            postre: postres[index],
            onAgregar: () {
              // Aquí se va a agregar el carrito
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Perfil'), onTap: () => Navigator.pushNamed(context, '/profile')),
            ListTile(title: Text('Carrito'), onTap: () => Navigator.pushNamed(context, '/cart')),
          ],
        ),
      ),
    );
  }
}
